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
    add_result ({error: false, result: result, code: code})
  end

  def error code, error
    payload = {
      whole: error,
      class: error.class,
      message: error.message} 
    add_result ({error: true, result: payload, code: code})
  end

  def all
    @values
  end

  def at line
    @values[line]
  end

  private

  def increase_line_number
     @line_number = @line_number + 1
  end

  def add_result payload
    payload[:line] = @line_number
    @values[@line_number] = payload
    increase_line_number
  end
end

class PryFormatter
  def self.format line
    new(line).format
  end

  def initialize line
    @line = line
  end

  def format
    code = code()
    result = result()
    line_number = line_number()

    "[#{line_number}] pry> #{code}\n=> #{result}"
  end

  private

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