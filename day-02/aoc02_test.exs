Code.load_file("aoc02.exs", __DIR__)

ExUnit.start()
ExUnit.configure(exclude: [pending: true], trace: true)

defmodule BoxIDTest do
  use ExUnit.Case

  @tag pending: false
  test "No  match " do
    assert AoC02.double_triple_count({0, 0}, 'abcdef') == {0, 0}
  end

  @tag pending: false
  test "Two and Three" do
    assert AoC02.double_triple_count({0, 0}, 'bababc') == {1, 1}
  end

  @tag pending: false
  test "Two" do
    assert AoC02.double_triple_count({0, 0}, 'abbcde') == {1, 0}
  end

  @tag pending: false
  test "Three" do
    assert AoC02.double_triple_count({0, 0}, 'abcccd') == {0, 1}
  end

  @tag pending: false
  test "Double Two" do
    assert AoC02.double_triple_count({0, 0}, 'aabcdd') == {1, 0}
  end

  @tag pending: false
  test "Two 2" do
    assert AoC02.double_triple_count({0, 0},'abcdee') == {1, 0}
  end

  @tag pending: false
  test "double three" do
    assert AoC02.double_triple_count({0, 0},'ababab') == {0, 1}
  end

  @tag pending: false
  test "checksum" do
    input = ['abcdef', 'bababc', 'abbcde', 'abcccd', 'aabcdd', 'abcdee', 'ababab']

    assert AoC02.checksum(input) == 12
  end

  @tag pending: false
  test "distance 1" do
    assert AoC02.distance('abcde', 'axcye') == 2
  end

  @tag pending: false
  test "distance 2" do
    assert AoC02.distance('fghij', 'fguij') == 1
  end

  @tag pending: false
  test "distance 3" do
    assert AoC02.distance('fghij', 'klmno') == 5
  end

  @tag pending: false
  test "distance 4" do
    assert AoC02.distance('fghij', 'fghij') == 0
  end

  @tag pending: false
  test "find distance 1 failed" do
    input = ['abcde', 'fghij', 'klmno', 'pqrst', 'fguij', 'axcye', 'wvxyz']
    assert AoC02.find_distance_one(input, 'aaaaa') == []
  end

  @tag pending: false
  test "find distance 1 success" do
    input = ['abcde', 'fghij', 'klmno', 'pqrst', 'fguij', 'axcye', 'wvxyz']
    assert AoC02.find_distance_one(input, 'fguij') == ['fghij']
  end

  @tag pending: false
  test "find common chars" do
    input = ['abcde', 'fghij', 'klmno', 'pqrst', 'fguij', 'axcye', 'wvxyz']
    assert AoC02.common_letters_id_distance_one(input) == 'fgij'
  end


end
