#!/usr/bin/env ruby
require 'rubygems'
require 'randprize'
 @headstails={ "T"=> {'odds'=> 2,'name'=>'win tails','value'=>0},"H"=> {'odds'=> 2,'name'=>'win heads','value'=>1}}
  @dice={}
  1.upto(6) {|i| @dice[i.to_s]= {'odds'=> 6,'name'=>"rolled #{i}",'value'=>i} }
   @pm=Randprize::ManagePrizes.new
   @pm.prize_list(@dice)
   @pm.prize_statistics
   puts "-------RUN DICE------"
   1.upto(6) { |i|  puts @pm.random_prize}