class FileType
  DESCRIPTORS = [
      # Images
      {
          name: 'JPEG image',
          extensions: %w(jpeg jpg),
          type: :image
      },
      {
          name: 'JPEG 2000 image',
          extensions: %w(jp2 j2k jpf jpx jpm mj2),
          type: :image
      },
      {
          name: 'TIFF image',
          extensions: %w(tiff tif),
          type: :image
      },
      {
          name: 'PNG image',
          extensions: %w(png),
          type: :image
      },

      # Raw Images
      {
          name: 'Adobe raw image',
          extensions: %w(dng),
          type: :raw_image
      },
      {
          name: 'Hasselblad raw image',
          extensions: %w(3fr),
          type: :raw_image
      },
      {
          name: 'Sony raw image',
          extensions: %w(arw srf sr2),
          type: :raw_image
      },
      {
          name: 'Casio raw image',
          extensions: %w(bay),
          type: :raw_image
      },
      {
          name: 'Canon raw image',
          extensions: %w(crw cr2),
          type: :raw_image
      },
      {
          name: 'Kodak raw image',
          extensions: %w(dcr kdc dcs drf k25),
          type: :raw_image
      },
      {
          name: 'Epson raw image',
          extensions: %w(erf),
          type: :raw_image
      },
      {
          name: 'Mamiya raw image',
          extensions: %w(mef),
          type: :raw_image
      },
      {
          name: 'Minolta raw image',
          extensions: %w(mrw),
          type: :raw_image
      },
      {
          name: 'Nikon raw image',
          extensions: %w(nef nrw),
          type: :raw_image
      },
      {
          name: 'Olympus raw image',
          extensions: %w(orf),
          type: :raw_image
      },
      {
          name: 'Fujifilm raw image',
          extensions: %w(raf),
          type: :raw_image
      },
      {
          name: 'Leica raw image',
          extensions: %w(raw rwl dng),
          type: :raw_image
      },
      {
          name: 'Panasonic raw image',
          extensions: %w(raw rw2),
          type: :raw_image
      },
      {
          name: 'Red One raw image',
          extensions: %w(r3d),
          type: :raw_image
      },
      {
          name: 'Pentax raw image',
          extensions: %w(ptx pef),
          type: :raw_image
      },
      {
          name: 'Samsung raw image',
          extensions: %w(srw),
          type: :raw_image
      },
      {
          name: 'Sigma raw image',
          extensions: %w(x3f),
          type: :raw_image
      },
      {
          name: 'ARRIFLEX raw image',
          extensions: %w(ari),
          type: :raw_image
      },
      {
          name: 'Phase One raw image',
          extensions: %w(cap iiq eip),
          type: :raw_image
      },
      {
          name: 'Imacon raw image',
          extensions: %w(fff),
          type: :raw_image
      },
      {
          name: 'Leaf raw image',
          extensions: %w(mos),
          type: :raw_image
      },
      {
          name: 'Logitech raw image',
          extensions: %w(pxn),
          type: :raw_image
      },
      {
          name: 'Rawzor raw image',
          extensions: %w(rwz),
          type: :raw_image
      },

      # Videos
      {
          name: 'API video',
          extensions: %w(avi),
          type: :video
      },
      {
          name: 'MOV video',
          extensions: %w(mov),
          type: :video
      },
      {
          name: 'MP4 video',
          extensions: %w(mp4),
          type: :video
      },
      {
          name: 'FLV video',
          extensions: %w(flv f4v),
          type: :video
      },
      {
          name: 'Matroska video',
          extensions: %w(mkv),
          type: :video
      }
  ]

  UNKNOWN_DESCRIPTOR = {
      name: 'Unknown file',
      extensions: [],
      type: 'unknown'
  }

  def self.file_descriptors(filename)
    descriptors = DESCRIPTORS.select {|fd| fd[:extensions].include? File.extname(filename).tr('.', '').downcase }
    descriptors.empty? ? [ UNKNOWN_DESCRIPTOR ] : descriptors
  end

  def self.file_type(filename)
    file_descriptors(filename).first[:type]
  end

end