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
        result.success(r)
      rescue StandardError => e
        result.error(e)
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

  def success result 
    store_at result, false
  end

  def error error 
    store_at error, true
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

  def store_at payload, error
    @values[@line_number] = {error: error, result: payload}
    increase_line_number
  end
end