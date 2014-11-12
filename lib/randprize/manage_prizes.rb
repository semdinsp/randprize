
module Randprize
  class ManagePrizes < Randprize::Base
    attr_accessor :myprizelist, :keylist, :myranges, :worstoddprize, :totalwinodds
# Take the prizes in array and massage the hashlist into something we can use
# Add ranges
# eg { key1=>{odds,name,value,key} key3=>{odds,name,value,key}
  def prize_list(prizehash)
    self.myprizelist=Marshal.load(Marshal.dump(prizehash))  #deep copy
    self.keylist=self.myprizelist.keys
    raise 'prizelist must have at least two entries' if self.keylist.size<2
    self.myranges={}
    self.worstoddprize=0
    self.totalwinodds=1
    calculate_worst_odds
    normalize_odds
    
  end
  def prize_statistics_by_prize
     self.keylist.each {  |key| odds=1
             keyodds=self.myprizelist[key]['odds']
             odds=self.myrange.max.to_f/keyodds if keyodds!="REMAINING"
             puts  "----#{self.myprizelist[key]['name']} odds 1 in #{odds.round}"     }
  end
  # return statistics about prize list
  # set non winning value to 0
  def prize_statistics
    calculate_total_odds
    total=self.myrange.max.to_f/self.totalwinodds.to_f
    puts "Total Odds: 1 in #{total.round}"
    prize_statistics_by_prize
  end
  # update total win odds for non zero value prizes
  def calculate_total_odds
     self.keylist.each {  |key|
       prize=self.myprizelist[key]
       self.totalwinodds=prize['odds']+self.totalwinodds if prize['value'].to_f!=0
     }
   end
  def calculate_worst_odds
    self.keylist.each {  |key|
  #    puts "key is #{key} odds are: #{self.myprizelist[key]['odds']}"
      self.worstoddprize=[self.myprizelist[key]['odds'],self.worstoddprize].max if self.myprizelist[key]['odds']!="REMAINING"
    }
   # puts "worst odds #{self.worstoddprize}"
  end
#calculate finish odds
# return two items
def calculate_finnish_value(akey,start)
  if self.myprizelist[akey]['odds']=="REMAINING"
    finish=self.worstoddprize
  else
    self.myprizelist[akey]['odds']=self.worstoddprize/self.myprizelist[akey]['odds']
    finish=self.myprizelist[akey]['odds']+start
  end
  finish=finish.round.to_i
  finish
end
# normalize the odds to the largest odd value.. 
# odds must be in format 1 in x
  def normalize_odds
    
    start=0
    finish=0
    self.keylist.each {  |key|
      finish=calculate_finnish_value(key,start)
      self.myranges[key]=(start...finish)  #excludes finish
      start=finish
    }
    range=(0...finish)
    self.set_prize_range(range)
    #odds now converted to outof of worst case
    #puts "#{self.myprizelist.inspect}"
    raise 'prize list does not have full coverage (less prizes than odds) ' if finish<self.worstoddprize
    raise 'prize list has more prizes than coverage (more prizes than odds) ' if finish>self.worstoddprize
  end
  
  def view_details
    puts "Prizes: [#{self.myprizelist.inspect}]\nRanges [#{self.myranges.inspect}]\nAll Prize Range: [#{self.myrange.inspect}]"
  end
  def set_prize_range(rng)
    self.myrange=rng
  end
  def random_prize
    self.check_prize(self.random_range)
  end
  def check_prize(randnum)
    #puts "ranges #{self.myranges.inspect}"
    foundkey=""
    self.keylist.each {|key| foundkey= key if self.myranges[key].include?(randnum)}
    raise "rand num wrong range #{randnum} #{self.myrange}" if !self.myrange.include?(randnum)
    raise "key not found check random number #{randnum} #{foundkey}" if !self.keylist.include?(foundkey)
    self.myprizelist[foundkey]
  end
  

   end    # Class
end    #Module