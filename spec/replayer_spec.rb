require_relative "../replayer.rb"

RSpec.describe 'replayer' do
  it 'should execute and return a whole file' do
    expect(Replayer.execute_all_in('repl2.log').all).to eq(
      {
        1=>{:error=>false, :result=>2, :code => "1+1", :line => 1},
        2=>{:error=>false, :result=>3, :code => "2+1", :line => 2},
        3=>{:error=>false, :result=>4, :code => "3+1", :line => 3}})
  end

  it 'should execute and return single line' do
    expect(Replayer.execute_all_in('repl2.log').at 2).to eq(
      {:error=>false, :result=>3, :code => "2+1", :line => 2})
  end
end

RSpec.describe 'formatter' do
  it 'should execute and return single success line' do
    expect(PryFormatter.format({:error=>false, :result=>3, :code => "2+1", :line => 2})).to eq(
      "[2] pry> 2+1\n=> 3")
  end
end