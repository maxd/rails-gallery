class window.PreviewBuilder
  constructor: (@previewWidth, @previewHeight) ->
    @cache = {}

  preview: (file) =>
    deferred = $.Deferred()

    if @cache[file.name]
      deferred.resolve(@cache[file.name])
    else
      switch file.fileType()
        when 'image'
          @prepareImagePreview file, (previewImage) =>
            @cache[file.name] = previewImage
            deferred.resolve(previewImage)
        else
          deferred.resolve(null)

    deferred.promise()

  prepareImagePreview: (file, completed) ->
    imageUrl = window.URL.createObjectURL(file)

    image = new Image
    image.onload = =>
      canvas = document.createElement('canvas')
      canvas.width = @previewWidth
      canvas.height = @previewHeight

      ratio = if image.width > image.height then @previewWidth / image.width else @previewHeight / image.height

      width = image.width * ratio
      height = image.height * ratio
      x = (@previewWidth - width) / 2
      y = (@previewHeight - height) / 2

      context = canvas.getContext '2d'
      context.drawImage(image, x, y, width, height)

      preview = canvas.toDataURL('image/jpg')
      completed(preview)

      window.URL.revokeObjectURL imageUrl

    image.src = imageUrl
