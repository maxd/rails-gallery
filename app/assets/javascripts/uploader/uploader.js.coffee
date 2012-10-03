class window.Uploader
  constructor: ->
    @uploadItems = []
    @uploading = false
    @uploadItemRenderer = new UploadItemRenderer
    @previewBuilder = new PreviewBuilder(64, 64)
    @maxUploadQueueSize = -1

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
    $('.main').on 'change.uploader', '.files-for-upload thead .select input[type=checkbox]', @selectAllUploadItem
    $('.main').on 'change.uploader', '.files-for-upload tbody .select input[type=checkbox]', @selectUploadItem
    $('.main').on 'click.uploader', '.delete-upload-item', @deleteUploadItem

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
    @updateUploadItems(files)
    @renderUploadItems()
    @updateActionStates()

  filterDuplicates: (files) =>
    _.filter files, (file) =>
      not _.any @uploadItems, (uploadItem) ->
        uploadItem.file.name == file.name || _.any uploadItem.relatedItems, (relatedItem) -> relatedItem.file.name == file.name

  updateUploadItems: (files) =>
    # Add images
    _.each files, (file) =>
      if file.fileType() == 'image'
        @uploadItems.push new UploadItem(file)

    # Add related RAW images
    _.each files, (file) =>
      if file.fileType() == 'raw_image'
        relatedUploadItem = new UploadItem(file)

        uploadItem = _.find @uploadItems, (uploadItem) => uploadItem.file.fileType() == 'image' && uploadItem.file.name.basename() == file.name.basename()
        if uploadItem
          uploadItem.relatedItems.push relatedUploadItem
        else
          relatedUploadItem.selected = false
          @uploadItems.push relatedUploadItem

    # Move Raw images to related items if possible
    uploadItems = _.clone(@uploadItems)
    _.each uploadItems, (rawUploadItem, index) =>
      if rawUploadItem.file.fileType() == 'raw_image'
        uploadItem = _.find uploadItems, (uploadItem) => uploadItem.file.fileType() == 'image' && uploadItem.file.name.basename() == rawUploadItem.file.name.basename()
        if uploadItem
          rawUploadItem.selected = true
          uploadItem.relatedItems.push rawUploadItem

          delete @uploadItems[index]
    @uploadItems = _.compact @uploadItems

    # Add video files
    _.each files, (file) =>
      if file.fileType() == 'video'
        @uploadItems.push new UploadItem(file)

    # Add other files
    _.each files, (file) =>
      if file.fileType() == 'unknown'
        uploadItem = new UploadItem(file)
        uploadItem.selected = false
        @uploadItems.push uploadItem

  renderUploadItems: =>
    sortedUploadItems = _.sortBy @uploadItems, (uploadItem) -> uploadItem.file.name

    # Update table rows
    partials = _.map sortedUploadItems, (uploadItem) =>
      @uploadItemRenderer.renderUploadItem uploadItem
    $('.files-for-upload tbody').html(partials.join('\n'))

    # Generate previews for images
    _.each sortedUploadItems, (uploadItem) =>
      @previewQueue.add uploadItem

  previewQueueCallback: (uploadItem) =>
    deferred = @previewBuilder.preview(uploadItem.file)
    $.when(deferred).done (preview) =>
      $("[data-id=#{uploadItem.id}] .preview-image").attr('src', preview) if preview
      @previewQueue.next()

      @updateActionStates()

  updateActionStates: =>
    $('.cancel-preview-generation').toggle(@previewQueue.size() != 0)

    $('.start-upload').attr('disabled', @uploading or not _.any(@uploadItems, (uploadItem) -> uploadItem.requireUpload()))
    $('.cancel-upload').attr('disabled', not @uploading or @uploadQueue.size() == 0)

    $('#select-all').attr('disabled', @uploading)
    $('.select-upload-item input').attr('disabled', @uploading)
    $('.delete-upload-item').attr('disabled', @uploading)

    @displayUploadProgress(100 - Math.round(100 * @uploadQueue.size() / @maxUploadQueueSize))

  cancelPreviewGeneration: =>
    @previewQueue.clear()
    @updateActionStates()

  startUpload: =>
    unless @uploading
      @uploading = true

      _.each @uploadItems, (uploadItem) =>
        if uploadItem.requireUpload() or _.any(uploadItem.relatedItems, (ri) -> ri.requireUpload())
          @uploadQueue.add uploadItem

      @maxUploadQueueSize = @uploadQueue.size()

      @updateActionStates()
    false

  uploadQueueCallback: (uploadItem) =>
    f = =>
      uploadItem.uploaded = true
      _.each uploadItem.relatedItems, (ri) -> ri.uploaded = true

      $(".main [data-id=#{uploadItem.id}] .select-upload-item").remove()

      @uploadQueue.next()

      if @uploadQueue.size() == 0
        @maxUploadQueueSize = -1
        @uploading = false

      @updateActionStates()

    setTimeout f, 2000

  displayUploadProgress: (percent) ->
    progressBar = $('.upload-progress')

    $('.bar', progressBar).width("#{percent}%").html(if percent > 10 then "#{percent}%" else "")
    if percent >= 0 and percent < 100
      progressBar.fadeIn()
    else
      progressBar.fadeOut()

  cancelUpload: =>
    if @uploading
      @uploadQueue.clear()
      @updateActionStates()

  selectAllUploadItem: (event) =>
    checked = $(event.currentTarget).prop('checked')

    $('.files-for-upload tbody .select input[type=checkbox]').prop('checked', checked)
    _.each @uploadItems, (uploadItem) -> uploadItem.selected = checked if uploadItem.file.fileType() in ['image', 'video']

    @updateActionStates()

    true

  selectUploadItem: (event) =>
    checked = $(event.currentTarget).prop('checked')
    id = $(event.currentTarget).closest('[data-id]').data('id')

    uploadItem = _.find(@uploadItems, (uploadItem) -> uploadItem.id == id)
    uploadItem.selected = checked

    @updateActionStates()

    true

  deleteUploadItem: (event) =>
    itemRow = $(event.currentTarget).closest('[data-id]')
    id = itemRow.data('id')

    _.each @uploadItems, (uploadItem, index) =>
      delete @uploadItems[index] if uploadItem.id == id
    @uploadItems = _.compact @uploadItems

    itemRow.remove()

    @updateActionStates()

  dispose: =>
    $('.main').off('.uploader')
    @previewQueue.clear()
