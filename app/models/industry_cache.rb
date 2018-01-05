class IndustryCache
  def initialize
    @contents = {}
  end

  def [] symbol
    if !@contents.includes? symbol
      # make api call

      # TODO!
      raise NotImplementedError

      # store in dictionary
      @contents[symbol] = APICALL
    end
    @contents.fetch symbol
  end
end

# i = IndustryCache.new
# i["GOOG"]


