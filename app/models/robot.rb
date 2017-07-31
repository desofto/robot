# frozen_string_literal: true

class Robot
  attr_reader :x, :y, :facing

  class InvalidCommandError < StandardError; end
  class Uninitialized < StandardError; end

  VALID_X_RANGE = (0..4)
  VALID_Y_RANGE = (0..4)

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  COMMANDS = %i[place move left right report].freeze

  FACING = %i[NORTH SOUTH EAST WEST].freeze

  validate :facing_must_be_listed
  validate :x_must_be_in_range
  validate :y_must_be_in_range

  def initialize
    @x = nil
    @y = nil
    @facing = nil
  end

  def command(cmd_line)
    cmd, params = parse_params(cmd_line)

    saved_state = state
    result = params.present? ? send(cmd, *params) : send(cmd)
    self.state = saved_state unless valid?

    result
  rescue Uninitialized
    nil
  end

  protected

  def state
    [@x, @y, @facing]
  end

  def state=(state)
    @x, @y, @facing = state
  end

  def parse_params(str)
    cmd, params = str.split(' ').map(&:strip)
    cmd.downcase!

    raise InvalidCommandError unless cmd.to_sym.in? COMMANDS

    params = params.split(',').map(&:strip) if params.present?

    [cmd, params]
  end

  def should_be_initialized
    return if @x.present? && @y.present? && @facing.present?
    raise Uninitialized
  end

  def place(x, y, facing)
    @x = x.to_i
    @y = y.to_i
    @facing = facing.upcase.to_sym
    nil
  end

  def move
    should_be_initialized
    case @facing
    when :NORTH then @y += 1
    when :SOUTH then @y -= 1
    when :EAST  then @x += 1
    when :WEST  then @x -= 1
    end
    nil
  end

  def left
    should_be_initialized
    @facing =
      case @facing
      when :NORTH then :WEST
      when :SOUTH then :EAST
      when :EAST  then :NORTH
      when :WEST  then :SOUTH
      end
    nil
  end

  def right
    should_be_initialized
    @facing =
      case @facing
      when :NORTH then :EAST
      when :SOUTH then :WEST
      when :EAST  then :SOUTH
      when :WEST  then :NORTH
      end
    nil
  end

  def report
    should_be_initialized

    state.join(',')
  end

  private

  def facing_must_be_listed
    return if @facing.in? FACING

    errors.add(:facing, :invalid)
  end

  def x_must_be_in_range
    return if @x.in? VALID_X_RANGE

    errors.add(:x, :invalid)
  end

  def y_must_be_in_range
    return if @y.in? VALID_Y_RANGE

    errors.add(:y, :invalid)
  end
end
