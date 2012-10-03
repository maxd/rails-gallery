class window.UploadItemRenderer
  renderUploadItem: (uploadItem) ->
    switch uploadItem.file.fileType()
      when 'image' then @renderImageItem(uploadItem)
      when 'raw_image' then @renderRawImageItem(uploadItem)
      when 'video' then @renderVideoItem(uploadItem)
      when 'unknown' then @renderUnknownItem(uploadItem)

  renderImageItem: (uploadItem) ->
    JST['templates/image_file_row']
      uploadItem: uploadItem
      prepareRelatedItemNames: (uploadItem) ->
        _.map @uploadItem.relatedItems, (relatedItem) ->
          _.map(FileType.fileDescriptors(relatedItem.file.name), (d) -> d.name).join(' or ')

  renderRawImageItem: (uploadItem) ->
    JST['templates/raw_image_file_row']
      uploadItem: uploadItem

  renderVideoItem: (uploadItem) ->
    JST['templates/video_file_row']
      uploadItem: uploadItem

  renderUnknownItem: (uploadItem) ->
    JST['templates/unknown_file_row']
      uploadItem: uploadItem
