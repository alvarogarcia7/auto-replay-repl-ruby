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
    result = {}
    line_number = 1
    lines.each do |line|
      begin
        r = eval(line)
        add_result(result, line_number, r)
      rescue StandardError => e
        add_error(result, line_number, e)
      end
      line_number = line_number + 1
    end
    result
  end

  def self.add_result holder, line_number, result 
    holder[line_number] = {error: false, result: result}
  end

  def self.add_error holder, line_number, error 
    holder[line_number] = {error: true, result: error}
  end

end