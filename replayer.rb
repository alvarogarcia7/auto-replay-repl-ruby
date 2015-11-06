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
        result[line_number] = {error: false, result: r}
      rescue StandardError => e
        result[line_number] = {error: true, result: e}
      end
      line_number = line_number + 1
    end
    result
  end

end