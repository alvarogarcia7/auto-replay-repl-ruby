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
    store_at code, result, false
  end

  def error code, error
    error = {
      whole: error,
      class: error.class,
      message: error.message} 
    store_at code, error, true
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

  def store_at code, result, error
    @values[@line_number] = {error: error, result: result, code: code, line: @line_number}
    increase_line_number
  end
end

class PryFormatter
  def self.format line
    if line[:error] then
      code = "#{line[:code]} # #{line[:result][:class]}"
      result = "# #{line[:result][:message]}"
    else
      code = "#{line[:code]}"
      result = "#{line[:result]}"
    end

    "[#{line[:line]}] pry> #{code}\n=> #{result}"
  end
end