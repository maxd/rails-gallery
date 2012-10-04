class window.MediaItemRenderer
  renderMediaItem: (mediaItem) ->
    switch mediaItem.file.fileType()
      when 'image' then @renderImageItem(mediaItem)
      when 'raw_image' then @renderRawImageItem(mediaItem)
      when 'video' then @renderVideoItem(mediaItem)
      when 'unknown' then @renderUnknownItem(mediaItem)

  renderImageItem: (mediaItem) ->
    JST['templates/image_file_row']
      mediaItem: mediaItem
      prepareAdditionalItemNames: (mediaItem) ->
        _.map mediaItem.additionalItems, (additionalItem) ->
          _.map(FileType.fileDescriptors(additionalItem.file.name), (d) -> d.name).join(' or ')

  renderRawImageItem: (mediaItem) ->
    JST['templates/raw_image_file_row']
      mediaItem: mediaItem

  renderVideoItem: (mediaItem) ->
    JST['templates/video_file_row']
      mediaItem: mediaItem

  renderUnknownItem: (mediaItem) ->
    JST['templates/unknown_file_row']
      mediaItem: mediaItem
