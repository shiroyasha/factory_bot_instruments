module IOHelper
  def self.capture(&block)
    begin
      $stdout = StringIO.new
      yield
      result = $stdout.string
    ensure
      $stdout = STDOUT
    end

    result
  end
end

