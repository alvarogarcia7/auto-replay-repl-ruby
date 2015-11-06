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
    @values[@line_number] = {error: false, result: result}
    @line_number = @line_number + 1
  end

  def error error 
    @values[@line_number] = {error: true, result: error}
    @line_number = @line_number + 1
  end

  def all
    @values
  end
end