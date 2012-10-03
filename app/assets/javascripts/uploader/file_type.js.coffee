class window.FileType
  @descriptors = [

    # Images
    {
      name: 'JPEG image',
      extensions: ['jpeg', 'jpg'],
      type: 'image'
    },
    {
      name: 'JPEG 2000 image',
      extensions: ['jp2', 'j2k', 'jpf', 'jpx', 'jpm', 'mj2'],
      type: 'image'
    },
    {
      name: 'TIFF image',
      extensions: ['tiff', 'tif'],
      type: 'image'
    },
    {
      name: 'PNG image',
      extensions: ['png'],
      type: 'image'
    },

    # Raw Images
    {
      name: 'Adobe raw image',
      extensions: ['dng'],
      type: 'raw_image'
    },
    {
      name: 'Hasselblad raw image',
      extensions: ['3fr'],
      type: 'raw_image'
    },
    {
      name: 'Sony raw image',
      extensions: ['arw', 'srf', 'sr2'],
      type: 'raw_image'
    },
    {
      name: 'Casio raw image',
      extensions: ['bay'],
      type: 'raw_image'
    },
    {
      name: 'Canon raw image',
      extensions: ['crw', 'cr2'],
      type: 'raw_image'
    },
    {
      name: 'Kodak raw image',
      extensions: ['dcr', 'kdc', 'dcs', 'drf', 'k25'],
      type: 'raw_image'
    },
    {
      name: 'Epson raw image',
      extensions: ['erf'],
      type: 'raw_image'
    },
    {
      name: 'Mamiya raw image',
      extensions: ['mef'],
      type: 'raw_image'
    },
    {
      name: 'Minolta raw image',
      extensions: ['mrw'],
      type: 'raw_image'
    },
    {
      name: 'Nikon raw image',
      extensions: ['nef', 'nrw'],
      type: 'raw_image'
    },
    {
      name: 'Olympus raw image',
      extensions: ['orf'],
      type: 'raw_image'
    },
    {
      name: 'Fujifilm raw image',
      extensions: ['raf'],
      type: 'raw_image'
    },
    {
      name: 'Leica raw image',
      extensions: ['raw', 'rwl', 'dng'],
      type: 'raw_image'
    },
    {
      name: 'Panasonic raw image',
      extensions: ['raw', 'rw2'],
      type: 'raw_image'
    },
    {
      name: 'Red One raw image',
      extensions: ['r3d'],
      type: 'raw_image'
    },
    {
      name: 'Pentax raw image',
      extensions: ['ptx', 'pef'],
      type: 'raw_image'
    },
    {
      name: 'Samsung raw image',
      extensions: ['srw'],
      type: 'raw_image'
    },
    {
      name: 'Sigma raw image',
      extensions: ['x3f'],
      type: 'raw_image'
    },
    {
      name: 'ARRIFLEX raw image',
      extensions: ['ari'],
      type: 'raw_image'
    },
    {
      name: 'Phase One raw image',
      extensions: ['cap', 'iiq', 'eip'],
      type: 'raw_image'
    },
    {
      name: 'Imacon raw image',
      extensions: ['fff'],
      type: 'raw_image'
    },
    {
      name: 'Leaf raw image',
      extensions: ['mos'],
      type: 'raw_image'
    },
    {
      name: 'Logitech raw image',
      extensions: ['pxn'],
      type: 'raw_image'
    },
    {
      name: 'Rawzor raw image',
      extensions: ['rwz'],
      type: 'raw_image'
    },

    # Videos
    {
      name: 'API video',
      extensions: ['avi'],
      type: 'video'
    },
    {
      name: 'MOV video',
      extensions: ['mov'],
      type: 'video'
    },
    {
      name: 'MP4 video',
      extensions: ['mp4'],
      type: 'video'
    },
    {
      name: 'FLV video',
      extensions: ['flv', 'f4v'],
      type: 'video'
    },
    {
      name: 'Matroska video',
      extensions: ['mkv'],
      type: 'video'
    },

  ]

  @unknownDescriptor = {
    name: 'Unknown file',
    extensions: [],
    type: 'unknown'
  }

  @fileDescriptors: (filename) ->
    descriptors = _.filter @descriptors, (fileDescriptor) ->
      filename.extension().toLowerCase() in fileDescriptor.extensions

    if _.isEmpty(descriptors) then [ @unknownDescriptor ] else descriptors

  @fileType: (filename) ->
    _.first(@fileDescriptors(filename)).type


File::fileType = ->
  @_fileType = FileType.fileType(@name) unless @_fileType
  @_fileType
