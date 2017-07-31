task robot: :environment do
  robot = Robot.new
  begin
    STDOUT.print '> '
    line = STDIN.gets&.strip
    break if line.blank?
    result = robot.command(line)
    STDOUT.puts result if result.present?
  end while line.present?
end
