class window.Uploader
  constructor: ->
    @mediaItems = []
    @uploading = false
    @mediaItemRenderer = new MediaItemRenderer
    @previewBuilder = new PreviewBuilder(64, 64)

    @progressValue = -1
    @maxProgressValue = -1

    @previewQueue = $.jqmq
      delay: -1
      batch: 1
      callback: @previewQueueCallback

    @uploadQueue = $.jqmq
      delay: -1
      batch: 1
      callback: @uploadQueueCallback

    $.event.props.push('dataTransfer')

    $('.main').on 'dragenter.uploader', '.drop-area', @highlightDropArea
    $('.main').on 'dragleave.uploader dragend.uploader drop.uploader', '.drop-area', @dimlightDropArea
    $('.main').on 'dragover.uploader', '.drop-area', @dragover
    $('.main').on 'drop.uploader', '.drop-area', @drop

    $('.main').on 'click.uploader', '.cancel-preview-generation', @cancelPreviewGeneration
    $('.main').on 'click.uploader', '.start-upload', @startUpload
    $('.main').on 'click.uploader', '.cancel-upload', @cancelUpload
    $('.main').on 'change.uploader', '.files-for-upload thead .select input[type=checkbox]', @selectAllMediaItems
    $('.main').on 'change.uploader', '.files-for-upload tbody .select input[type=checkbox]', @selectMediaItem
    $('.main').on 'click.uploader', '.delete-media-item', @deleteMediaItem

    @updateActionStates()

  highlightDropArea: (event) ->
    if event.target == this
      $(@).addClass 'highlight'

  dimlightDropArea: (event) ->
    if event.target == this
      $(@).removeClass 'highlight'

  dragover: (event) ->
    event.preventDefault();

    event.dataTransfer.dropEffect = 'copy'

  drop: (event) =>
    event.preventDefault();

    files = event.dataTransfer.files

    files = @filterDuplicates(files)
    @updateMediaItems(files)
    @renderMediaItems()
    @updateActionStates()

  filterDuplicates: (files) =>
    _.filter files, (file) =>
      not _.any @mediaItems, (mediaItem) ->
        mediaItem.file.name == file.name || _.any mediaItem.additionalItems, (additionalItem) -> additionalItem.file.name == file.name

  updateMediaItems: (files) =>
    # Add images
    _.each files, (file) =>
      if file.fileType() == 'image'
        @mediaItems.push new MediaItem(file)

    # Add related RAW images
    _.each files, (file) =>
      if file.fileType() == 'raw_image'
        additionalItem = new MediaItem(file)

        mediaItem = _.find @mediaItems, (mediaItem) => mediaItem.file.fileType() == 'image' && mediaItem.file.name.basename() == file.name.basename()
        if mediaItem
          mediaItem.additionalItems.push additionalItem
        else
          additionalItem.selected = false
          @mediaItems.push additionalItem

    # Move Raw images to related items if possible
    mediaItems = _.clone(@mediaItems)
    _.each mediaItems, (additionalMediaItem, index) =>
      if additionalMediaItem.file.fileType() == 'raw_image'
        mediaItem = _.find mediaItems, (mediaItem) => mediaItem.file.fileType() == 'image' && mediaItem.file.name.basename() == additionalMediaItem.file.name.basename()
        if mediaItem
          additionalMediaItem.selected = true
          mediaItem.additionalItems.push additionalMediaItem

          delete @mediaItems[index]
    @mediaItems = _.compact @mediaItems

    # Add video files
    _.each files, (file) =>
      if file.fileType() == 'video'
        @mediaItems.push new MediaItem(file)

    # Add other files
    _.each files, (file) =>
      if file.fileType() == 'unknown'
        mediaItem = new MediaItem(file)
        mediaItem.selected = false
        @mediaItems.push mediaItem

    @mediaItems = _.sortBy @mediaItems, (mediaItem) -> mediaItem.file.name

  renderMediaItems: =>
    # Update table rows
    rows = _.map @mediaItems, (mediaItem) =>
      @mediaItemRenderer.renderMediaItem mediaItem

    table = JST['templates/files_for_upload_table'](body: rows.join('\n'))

    $('.files-for-upload').html(table)

    # Generate previews for images
    _.each @mediaItems, (mediaItem) =>
      @previewQueue.add mediaItem

  previewQueueCallback: (mediaItem) =>
    deferred = @previewBuilder.preview(mediaItem.file)
    $.when(deferred).done (preview) =>
      $("[data-id=#{mediaItem.id}] .preview-image").attr('src', preview) if preview
      @previewQueue.next()

      @updateActionStates()

  updateActionStates: =>
    $('.cancel-preview-generation').toggle(@previewQueue.size() != 0)

    $('.start-upload').attr('disabled', @uploading or not _.any(@mediaItems, (mediaItem) -> mediaItem.requireUpload()))
    $('.cancel-upload').attr('disabled', not @uploading or @uploadQueue.size() == 0)

    $('#select-all').attr('disabled', @uploading)
    $('.select-upload-item input').attr('disabled', @uploading)
    $('.delete-upload-item').attr('disabled', @uploading)

    @displayUploadProgress(Math.round(100 * @progressValue / @maxProgressValue))

  displayUploadProgress: (percent) =>
    progressBar = $('.upload-progress')

    $('.bar', progressBar).width("#{percent}%").html(if percent > 10 then "#{percent}%" else "")
    if @maxProgressValue != -1
      progressBar.fadeIn()
    else
      progressBar.fadeOut()

  cancelPreviewGeneration: =>
    @previewQueue.clear()
    @updateActionStates()

  startUpload: =>
    unless @uploading
      @uploading = true

      uploadItems = _.filter @mediaItems, (mediaItem) => mediaItem.requireUpload()
      _.each uploadItems, (mediaItem) =>
        @uploadQueue.add mediaItem

      @progressValue = 0
      @maxProgressValue = uploadItems.length

      @updateActionStates()
    false

  uploadQueueCallback: (mediaItem) =>
    @uploadMediaItem mediaItem, =>
      @uploadQueue.next()

      @progressValue += 1

      if @progressValue == @maxProgressValue
        @progressValue = -1
        @maxProgressValue = -1
        @uploading = false

      @updateActionStates()

  uploadMediaItem: (mediaItem, completeCallback) =>
    successUpload = (json, textStatus, xhr) =>
      mediaItem.uploaded = true

      $(".main [data-id=#{mediaItem.id}] .select-media-item").remove()

      $(".main [data-id=#{mediaItem.id}]").removeClass('alert-error')
      $(".main [data-id=#{mediaItem.id}]").addClass('alert-success')
      $(".main [data-id=#{mediaItem.id}] td.message").html(json.message)

    failUpload = (xhr, textStatus, errorThrown) =>
      message = ""
      try
        json = $.parseJSON(xhr.responseText)
        message = json.message
      catch e
        message = errorThrown

      $(".main [data-id=#{mediaItem.id}]").addClass('alert-error')
      $(".main [data-id=#{mediaItem.id}] td.message").html(message)

    csrfParam = $('meta[name=csrf-param]').attr('content')
    csrfToken = $('meta[name=csrf-token]').attr('content')
    albumId = $('.uploader').data('album-id')

    formData = new FormData
    formData.append csrfParam, csrfToken
    formData.append 'upload[album_ids]', albumId if albumId?.length != 0
    formData.append 'upload[file]', mediaItem.file
    _.each mediaItem.additionalItems, (additionalItem) ->
      formData.append 'upload[additional_items_attributes][][file]', additionalItem.file

    uploadHandler = $.ajax
      url: '/upload'
      type: 'POST'
      contentType: false
      processData: false
      data: formData
      dataType: 'json'
      cache: false
    uploadHandler.success successUpload
    uploadHandler.error failUpload
    uploadHandler.complete completeCallback

  cancelUpload: =>
    if @uploading
      @uploadQueue.clear()
      @updateActionStates()

  selectAllMediaItems: (event) =>
    checked = $(event.currentTarget).prop('checked')

    $('.files-for-upload tbody .select input[type=checkbox]').prop('checked', checked)
    _.each @mediaItems, (mediaItem) -> mediaItem.selected = checked if mediaItem.file.fileType() in ['image', 'video']

    @updateActionStates()

    true

  selectMediaItem: (event) =>
    checked = $(event.currentTarget).prop('checked')
    id = $(event.currentTarget).closest('[data-id]').data('id')

    mediaItem = _.find(@mediaItems, (mediaItem) -> mediaItem.id == id)
    mediaItem.selected = checked

    @updateActionStates()

    true

  deleteMediaItem: (event) =>
    itemRow = $(event.currentTarget).closest('[data-id]')
    id = itemRow.data('id')

    _.each @mediaItems, (mediaItem, index) =>
      delete @mediaItems[index] if mediaItem.id == id
    @mediaItems = _.compact @mediaItems

    itemRow.remove()

    @updateActionStates()

  dispose: =>
    $('.main').off('.uploader')
    @previewQueue.clear()
    @uploadQueue.clear()
