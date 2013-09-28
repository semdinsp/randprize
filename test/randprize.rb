require File.dirname(__FILE__) + '/test_helper.rb'

class RandprizeTest < Test::Unit::TestCase

  def setup
    @f=Randprize::Base.new
  end
  
  def test_basic
    assert @f.rand!=nil, "should return result"
  end
  def test_assign_gen
    @f.set_random_generator(Random.new)
    assert @f.random_generator!=Random.new, "diff generatros"
  end
  def test_range
    range=(0..10)
    @f.set_range(range)
    1.upto(100) do
      res=@f.rand_range
      assert range.include?(res), "range return wrong #{res}"
    end
  end
  
 
 

end