module XML
  module ElementParser
    def self.parse(element)
      attributes = {}
      element.elements.each do |child|
        attributes[child.name.to_sym] = child.text if child.elements.size == 0
      end
      attributes
    end
  end
end
