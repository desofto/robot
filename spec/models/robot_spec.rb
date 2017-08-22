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

  context 'rotates' do
    before do
      robot.command('PLACE 2,2,NORTH')
    end

    it 'to left' do
      robot.command('LEFT')
      state = robot.command('REPORT')
      expect(state).to eq '2,2,WEST'

      robot.command('LEFT')
      state = robot.command('REPORT')
      expect(state).to eq '2,2,SOUTH'

      robot.command('LEFT')
      state = robot.command('REPORT')
      expect(state).to eq '2,2,EAST'

      robot.command('LEFT')
      state = robot.command('REPORT')
      expect(state).to eq '2,2,NORTH'
    end

    it 'to right' do
      robot.command('RIGHT')
      state = robot.command('REPORT')
      expect(state).to eq '2,2,EAST'

      robot.command('RIGHT')
      state = robot.command('REPORT')
      expect(state).to eq '2,2,SOUTH'

      robot.command('RIGHT')
      state = robot.command('REPORT')
      expect(state).to eq '2,2,WEST'

      robot.command('RIGHT')
      state = robot.command('REPORT')
      expect(state).to eq '2,2,NORTH'
    end
  end

  context 'moves' do
    it 'NORTH' do
      robot.command('PLACE 2,2,NORTH')

      robot.command('MOVE')
      state = robot.command('REPORT')

      expect(state).to eq '2,3,NORTH'
    end

    it 'SOUTH' do
      robot.command('PLACE 2,2,SOUTH')

      robot.command('MOVE')
      state = robot.command('REPORT')

      expect(state).to eq '2,1,SOUTH'
    end

    it 'EAST' do
      robot.command('PLACE 2,2,EAST')

      robot.command('MOVE')
      state = robot.command('REPORT')

      expect(state).to eq '3,2,EAST'
    end

    it 'WEST' do
      robot.command('PLACE 2,2,WEST')

      robot.command('MOVE')
      state = robot.command('REPORT')

      expect(state).to eq '1,2,WEST'
    end
  end

  context 'does not drop from table' do
    it 'NORTH' do
      robot.command('PLACE 2,4,NORTH')

      robot.command('MOVE')
      state = robot.command('REPORT')

      expect(state).to eq '2,4,NORTH'
    end

    it 'SOUTH' do
      robot.command('PLACE 2,0,SOUTH')

      robot.command('MOVE')
      state = robot.command('REPORT')

      expect(state).to eq '2,0,SOUTH'
    end

    it 'EAST' do
      robot.command('PLACE 4,2,EAST')

      robot.command('MOVE')
      state = robot.command('REPORT')

      expect(state).to eq '4,2,EAST'
    end

    it 'WEST' do
      robot.command('PLACE 0,2,WEST')

      robot.command('MOVE')
      state = robot.command('REPORT')

      expect(state).to eq '0,2,WEST'
    end
  end

  context 'complex tests from the task description' do
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
end
