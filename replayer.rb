class Replayer
  def self.execute_all_in file
    lines = read_lines(file)
    execute_all(lines)
  end

  private

  def self.read_lines file
    result = [];

    File.foreach( file ) do |line|
      result << "#{line}"
    end
    
    result
  end

  def self.execute_all lines
    result = Results.new
    cumulate_in result, lines
  end

  def self.cumulate_in result, lines
    lines.each do |line|
      begin
        r = eval(line)
        result.success(line.strip, r)
      rescue StandardError => e
        result.error(line.strip, e)
      end
    end
    result
  end

end

class Results
  def initialize
    @values = {}
    @line_number = 1
  end

  def success code, result
    a_new.successful_line.with(code).producing(result)
  end

  def a_new
    @line = ResultsBuilder.new (self)
  end

  def error code, error
    a_new.error_line.with(code).producing(error)
  end

  def all
    @values
  end

  def at line
    @values[line]
  end

  def add_result payload
    payload[:line] = @line_number
    @values[@line_number] = payload
    increase_line_number
  end
  private

  def increase_line_number
     @line_number = @line_number + 1
  end

end

class ResultsBuilder
  def initialize results
    @results = results
  end

  def producing result
    @result = result
    if @error
      @result = {
        whole: result,
        class: result.class,
        message: result.message} 
    end
    build
  end

  def add_result payload
    @results.add_result payload
  end

  def successful_line
    @error = false
    self
  end

  def error_line
    @error = true
    self
  end

  def with code
    @code = code
    self
  end

  def build
    add_result ({error: @error, result: @result, code: @code})
    self
  end
end

class PryFormatter
  def self.format line
    new(line).format
  end

  def format
    "[#{line_number}] pry> #{code}\n=> #{result}"
  end

  private

  def initialize line
    @line = line
  end

  def line_number
    @line[:line]
  end

  def code
    code = "#{@line[:code]}"
    if error? then
      code = code + " # #{@line[:result][:class]}"
    end
    code
  end

  def result
    result = "#{@line[:result]}"
    if error? then
      result = "# #{@line[:result][:message]}"
    end
    result
  end

  def error?
    @line[:error]
  end
end