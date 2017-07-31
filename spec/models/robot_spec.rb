# frozen_string_literal: true

require 'rails_helper'

describe Robot do
  let(:robot) { build(:robot) }

  it 'invalid command' do
    expect do
      robot.command('invalid')
    end.to raise_exception Robot::InvalidCommandError
  end

  it 'not initialized' do
    robot.command('MOVE')

    state = robot.command('REPORT')

    expect(state).to be_nil
  end

  it 'invalid facing' do
    robot.command('PLACE 0,0,NOR')

    expect(robot).not_to be_valid
    expect(robot.errors[:facing]).not_to be_empty
  end

  it 'invalid placement' do
    robot.command('PLACE 5,5,NORTH')

    expect(robot).not_to be_valid
    expect(robot.errors[:facing]).not_to be_empty

    robot.command('MOVE')
    state = robot.command('REPORT')

    expect(state).to be_nil

    robot.command('PLACE 0,0,NORTH')
    expect(robot).to be_valid

    state = robot.command('REPORT')
    expect(state).to eq '0,0,NORTH'
  end

  it 'test 1' do
    robot.command('PLACE 0,0,NORTH')
    robot.command('MOVE')
    state = robot.command('REPORT')

    expect(state).to eq '0,1,NORTH'
  end

  it 'test 2' do
    robot.command('PLACE 0,0,NORTH')
    robot.command('LEFT')
    state = robot.command('REPORT')

    expect(state).to eq '0,0,WEST'
  end

  it 'test 3' do
    robot.command('PLACE 1,2,EAST')
    robot.command('MOVE')
    robot.command('MOVE')
    robot.command('LEFT')
    robot.command('MOVE')
    state = robot.command('REPORT')

    expect(state).to eq '3,3,NORTH'
  end
end
