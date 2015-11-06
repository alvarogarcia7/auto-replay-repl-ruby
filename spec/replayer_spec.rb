require_relative "../replayer.rb"

RSpec.describe 'replayer' do
  it 'should execute a file' do
    expect(Replayer.execute_all_in('repl2.log')).to eq(
      {
        1=>{:error=>false, :result=>2},
        2=>{:error=>false, :result=>3},
        3=>{:error=>false, :result=>4}})
  end
end