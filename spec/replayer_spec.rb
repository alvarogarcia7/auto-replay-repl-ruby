require_relative "../replayer.rb"

RSpec.describe 'replayer' do
  it 'should execute and return a whole file' do
    expect(Replayer.execute_all_in('repl2.log').all).to eq(
      {
        1=>{:error=>false, :result=>2},
        2=>{:error=>false, :result=>3},
        3=>{:error=>false, :result=>4}})
  end

  it 'should execute and return single line' do
    expect(Replayer.execute_all_in('repl2.log').at 2).to eq(
      {:error=>false, :result=>3})

  end
end