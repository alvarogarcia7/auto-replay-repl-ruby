class Replayer
  def self.execute_all_in file
    lines = [];

    File.foreach( file ) do |line|
      lines << "#{line}"
    end

    result = {}
    line_number = 1
    lines.map do |line|
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