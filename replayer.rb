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
    line_number = 1
    lines.each do |line|
      begin
        r = eval(line)
        result.success(line_number, r)
      rescue StandardError => e
        result.error(line_number, e)
      end
      line_number = line_number + 1
    end
    result
  end

end

class Results
  def initialize
    @values = {}
  end

  def success line_number, result 
    @values[line_number] = {error: false, result: result}
  end

  def error line_number, error 
    @values[line_number] = {error: true, result: error}
  end

  def all
    @values
  end
end