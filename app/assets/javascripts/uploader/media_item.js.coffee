class window.MediaItem
  constructor: (@file) ->
    @id = _.uniqueId('media-item-')
    @selected = true
    @uploaded = false
    @additionalItems = []

  requireUpload: =>
    @selected and not @uploaded and @file.fileType() in ['image', 'video']

