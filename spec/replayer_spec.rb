require_relative "../replayer.rb"

RSpec.describe 'replayer' do

  def to_s results
    if results.key? :result
      results[:result] = results[:result].message
    else
      results.values.map { |result|
          result[:result] = result[:result].message
      }
    end
    results
  end
  it 'should execute and return a whole file' do
    expect(Replayer.execute_all_in('spec/repl2.log').all).to eq(
      {
        1=>{:error=>false, :result=>2, :code => "1+1", :line => 1},
        2=>{:error=>false, :result=>3, :code => "2+1", :line => 2},
        3=>{:error=>false, :result=>4, :code => "3+1", :line => 3}})
  end

  it 'should execute and return single line' do
    expect(Replayer.execute_all_in('spec/repl2.log').at 2).to eq(
      {:error=>false, :result=>3, :code => "2+1", :line => 2})
  end

  it 'should execute and return single error line' do
  	line = Replayer.execute_all_in('spec/unexisting_variable.log').at 1
    expect(to_s(line)).to eq(
      {:error=>true, :result=>"undefined local variable or method `a' for Replayer:Class", :code => "1+a", :line => 1})
  end

  it 'should execute and return a whole error file' do
    file = Replayer.execute_all_in('spec/unexisting_variable.log').all
    expect(to_s(file)).to eq(
      {
        1=>{:error=>true, :result=>"undefined local variable or method `a' for Replayer:Class", :code => "1+a", :line => 1},
        2=>{:error=>true, :result=>"undefined local variable or method `b' for Replayer:Class", :code => "9*b", :line => 2}
      })
  end
end

RSpec.describe 'formatter' do
  it 'should execute and return single success line' do
    expect(PryFormatter.format({:error=>false, :result=>3, :code => "2+1", :line => 2})).to eq(
      "[2] pry> 2+1\n=> 3")
  end
end