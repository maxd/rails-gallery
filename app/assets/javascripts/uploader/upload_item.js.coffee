class window.UploadItem
  constructor: (@file) ->
    @id = _.uniqueId('upload-item-')
    @selected = true
    @uploaded = false
    @relatedItems = []

  requireUpload: =>
    @selected and not @uploaded

