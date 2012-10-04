# encoding: utf-8

class AdditionalItemUploader < ItemUploader

  def extension_white_list
    FileType::DESCRIPTORS.map {|d| d[:extensions] }.flatten.uniq
  end

end
