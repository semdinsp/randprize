require File.dirname(__FILE__) + '/test_helper.rb'

class RandprizeTest < Test::Unit::TestCase

  def setup
    @f=Randprize::Base.new
    @pm=Randprize::ManagePrizes.new
    @headstails={ "T"=> {'odds'=> 2,'name'=>'win tails','value'=>0},"H"=> {'odds'=> 2,'name'=>'win heads','value'=>1}}
    @dice={}
    1.upto(6) {|i| @dice[i.to_s]= {'odds'=> 6,'name'=>"rolled #{i}",'value'=>i} }
    @large={ "GP"=> {'odds'=> 100,'name'=>'grandprize','value'=>50000},"H"=> {'odds'=> 'REMAINING','name'=>'win heads','value'=>1}}
     @exlarge={ "GP"=> {'odds'=> 50000,'name'=>'grandprize','value'=>50000},"2nd"=> {'odds'=> 5000,'name'=>'2ndprize','value'=>50000},"H"=> {'odds'=> 'REMAINING','name'=>'win heads','value'=>1}}
    
  end
  
  def test_basic
    assert @f.rand!=nil, "should return result"
  end
  def test_assign_gen
    @f.set_random_generator(Random.new)
    assert @f.random_generator!=Random.new, "diff generatros"
  end
  def test_view
    assert_nothing_raised do
     @pm.prize_list(@exlarge)
     @pm.view_details
    end
      
  end
  def test_range
    range=(0..10)
    @f.set_range(range)
    1.upto(100) do
      res=@f.random_range
      assert range.include?(res), "range return wrong #{res}"
    end
  end
  def test_range2
    range=(10..20)
    @f.set_range(range)
    1.upto(100) do
      res=@f.random_range
      assert range.include?(res), "range return wrong #{res}"
    end
  end
  def test_extralarge
       @pm.prize_list(@exlarge)
       assert @pm.keylist.include?("GP"), "only one key"
       assert @pm.check_prize(0)['name']=='grandprize', "shuld return 1"
       assert @pm.check_prize(5)['name']=='2ndprize', "shuld return 6"   
   end
  def test_large
       @pm.prize_list(@large)
       assert @pm.keylist.include?("GP"), "only one key"
       assert @pm.check_prize(0)['name']=='grandprize', "shuld return 1"
      assert @pm.check_prize(5)['name']=='win heads', "shuld return 6"   
   end
  def test_dice
      1.upto(10)  do
       @pm.prize_list(@dice)
       assert @pm.keylist.include?("1"), "only one key"
       assert @pm.check_prize(0)['name']=='rolled 1', "shuld return 1"
        assert @pm.check_prize(5)['name']=='rolled 6', "shuld return 6"
      end
   end
    def test_aaaworstodds
     
      @pm.prize_list(@headstails)
       puts "worstodds Here:  #{@pm.worstoddprize}"
      assert @pm.worstoddprize=2,"worst odds set correctly  #{@pm.worstoddprize}"
    end
   def test_scott
     puts "SCOTTT Here"
     @pm.prize_list(@headstails)
     assert @pm.worstoddprize=2,"worst odds set correctly"
     aprize=@pm.random_prize
     puts "aprize is #{aprize}, count "
     puts " myrange #{@pm.myrange} rand range returns: #{@pm.random_range}"
       puts "should be heads #{@pm.check_prize(1)} tails #{@pm.check_prize(0)}"
      @pm.view_details
      1.upto(200) do
         rn= @pm.random_range
         assert rn<2, "rand shuld be less than 2 for #{@pm.myrange}  "   
      end
   end
   def test_randomprize_forrandom
       steps=4000
       count=0
       1.upto(steps)  do
        @pm.prize_list(@headstails)
        prizes=[]
        @pm.myprizelist.each {|k| #puts "K is #{k}"
                             prizes << k[1]}
        aprize=@pm.random_prize
        assert prizes.include?(aprize), "prize should be from the list"    
        #puts  "count #{count} aprize #{aprize}"
        count=aprize['value']+count     
        end
       ratio=(count.to_f/steps)*100
       assert (49..51).include?(ratio.round), "ratio wrong #{ratio.round} count #{count}"
    end
     def test_randomprize
         1.upto(20)  do
          @pm.prize_list(@headstails)
          prizes2=[]
          @pm.myprizelist.each {|k| #puts "K is #{k}"
                               prizes2 << k[1]}
         # puts "prizes2 are: #{prizes2.inspect}"
          aprize2=@pm.random_prize
          assert prizes2.include?(aprize2), "prize should be from the list #{prizes2} #{aprize2}"    
         end
      end
  def test_prizemanager_binomials
     1.upto(25)  do
      @pm.prize_list(@headstails)
      assert @pm.keylist.include?("H"), "only one key"
      assert @pm.check_prize(0)['name']=='win tails', "shuld return tails"
       assert @pm.check_prize(1)['name']=='win heads', "shuld return heads"
     end
  end
  def test_acheckprize
         @pm.prize_list(@headstails)
         assert @pm.check_prize(1)['name']=='win heads', "shuld return heads"
         assert_raise(RuntimeError) do
          @pm.check_prize(7)
        end 
         assert_raise(RuntimeError) do
          @pm.check_prize(2)
        end
        assert_nothing_raised do
          @pm.check_prize(1)
        end 
   end
  def test_prizemanager_not_enough_prizes
     @prize1={ "0"=> {'odds'=> 2,'name'=>'win nothing','value'=>0}}
     
    assert_raise(RuntimeError) do
      @pm.prize_list(@prize1)
      assert @pm.keylist.include?("0"), "only one key"
    end
    
  end
  def test_prizemanager_bad_range
     @prize2badrange={ "0"=> {'odds'=> 2,'name'=>'win nothing','value'=>0},"1"=> {'odds'=> 10,'name'=>'win something','value'=>10}}
     assert_raise(RuntimeError) do
        @pm.prize_list(@prize2badrange)
        assert @pm.keylist.include?("0"), "only one key"
      end
    
    
  end
  
 
 

end