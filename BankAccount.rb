require 'csv'
#require money *******

module Bank
    #this is WAVE 1:
  class Account
    attr_accessor :id, :balance, :creation_date #these are like the instance variables, but now methods

    def initialize (account_hash)   #initialize is actually a class method
      @id = account_hash[:id].to_i
      @balance = account_hash[:initial_balance].to_i
        if @balance < 0
          raise ArgumentError.new("Nope.")
        end
      @creation_date = account_hash[:creation_date] #these are the hash key

    end

    def withdraw(amount) #local variable
     #puts "How much would you like to withdraw?"
     # amount = gets.chomp
      if (amount) < @balance
          @balance = @balance - (amount)
          printf("Balance: $%.2f\n", balance) #return @balance ****(this was being returned whether amount was < or > @balance)
       else
          puts "Nope."  #this is what happens if you're trying to withdraw more than you have; cant go negative
      end
    end

    def deposit(amount)
      #puts "How much would you like to deposit?"
      #amount = gets.chomp
        @balance = @balance + (amount)
        printf("Balance: $%.2f\n", balance)
    end




     #this is WAVE 2:
     #this method will access the id, amount and date
     #and on each iteration put the cooresponding indexes together in a new array
     #since each line in the csv file is a seperate array, i want to return the ______

    #THIS ISNT WORKING YET*******
    # def create_new(csv_index)
    #   account_array = []
    #   account_array = CSV.read("./support/accounts.csv", 'r')
    #   #So this is going through the file and it's saying that whatever the person choses for the csv_index,
    #   #Go through that index and assign each of the internal indexes to instance variables****
    #       @id = account_array[csv_index][0]
    #       @balance = account_array[csv_index][1]
    #       @open_date = account_array[csv_index][2]
    #
    #   puts "#{@id}"
    #   printf("Balance: $%.2f\n", balance),
    #   puts "#{@open_date}."
    # end


    def self.all
      final_accounts = []
      account_array = []
      account_array = CSV.read("./support/accounts.csv", 'r') #this is reading the csv file and creating and array of arrays
       #at this point we could say:
       #account_array[0][0] to get the ID of the first inner array; bc its an array still so we can call on the index

       #iterating through the array and setting each index within the inner array to the hash below(then we can call on a key instead of an index)
      account_array.each do |account| # local variable you can use within your loop
        #this is making an account_hash to hold the info
        account_hash = {id: account[0], initial_balance: account[1], creation_date: account[2]}
       #making new bank account from my account_hash I just created, but I need to save it somewhere, see below:
        final_accounts << Bank::Account.new(account_hash)  #converting the hash into a bank account, and storing it in a final array
        #(with the .new so its running through the initialize method here BEFORE the next step)
      end
        return final_accounts  #this is an array of Bank:: Account instances***
    end



      # Now....find the bank account array where the id matches the user-requested id
    def self.find(id) #need to switch either this to a string or the string in the array to fixnums
      id = id.to_s
      account_array = []
      account_array = CSV.read("./support/accounts.csv", 'r')
      info_hash = {}
       #same as above to create an array of the csv file
       #iterate through this array and set each index in each inner array as a has with these things below:
      account_array.each do |id_requested|    #length.times do |id_requested|(could also do it this way)
        if id_requested[0] == id    #if id matches the user-requested id, do thisL
          info_hash[:id] = id_requested[0]
          info_hash[:initial_balance] = id_requested[1]
          info_hash[:creation_date] = id_requested[2]
          your_acct = Bank::Account.new(info_hash)
          return your_acct   #break out of the loop when you find the id that matchs
        end
      end
          return nil     #return nil if the id is not found (this needs to be outside the method that is finding the id)
    end


     #******remember the balances include cents at the last two positions.
     #install money gem on terminal then require it up top***********
     #turns into a money object
     #or
     #printf, but not for interest, otherwise if interest amount is small and you round it to the 2nd decimal it will not look like much

     #This is for if interacting with ppl running in terminal (but not irb)
      #"Welsome to whatever bank....what would you like to do?"
      # action = gets.chomp
      #if action == withdraw
       #withdraw
      #elsif action == deposit
        #deposit
      #end

  end
      #this is WAVE 3:

  class Savings_Account < Account
    attr_accessor :id, :balance, :creation_date   #these are now methods!
    def initialize (account_info)   #initialize is actually a class method called on by .new
        #these are the hash keys:
      @id = account_info[:id].to_i
      @balance = account_info[:initial_balance].to_i
        if @balance < 10      #cannot start a new account with less than $10 minimum balance
          raise ArgumentError.new("Nope.")
        end
      @creation_date = account_info[:creation_date]

    end

    def withdraw(amount) #local variable
     #puts "How much would you like to withdraw?"
     # amount = gets.chomp          #I DIDNT DO @balance HERE (Metz-ing it!)
      if ((amount) < balance) && ((balance - (amount) - 2) >= 10)  #if amount wanting to withdraw -2 does not leave more than or at least $10 in account
          @balance = (@balance - (amount)) - 2
          puts "$ #{@balance}"
      else
          puts "Nope."
          puts "Balance: $ #{@balance}"
      end
    end


    def add_interest(rate) #this is coming in as a float so i dont need to .to_f
      interest = balance * rate/100
      @balance = balance + interest  #***can i do the %f on this without printf-ing it??****
      return interest
    end


  end



  class Checking_Account < Account
    attr_accessor :id, :balance, :creation_date
    def initialize (account_info)
      @id = account_info[:id].to_i
      @balance = account_info[:initial_balance].to_i
        if @balance < 0 #***This isnt necessary bc its not in the instructions****
          raise ArgumentError.new("Nope.")
        end
      @creation_date = account_info[:creation_date] #these are the hash key

    end

    def withdraw(amount) #local variable
     #puts "How much would you like to withdraw?"
     # amount = gets.chomp
      if ((amount) < balance) && ((balance - (amount)) > 0) #*****TEST THIS AGAIN!!*****
          @balance = (@balance - (amount)) - 1
          puts "#{@balance}"
      else
          puts "Nope."
      end
    end

    def withdraw_using_check(amount)
      if ((amount) < balance) && ((balance - (amount)) >= -10)  #Allows the account to go into overdraft up to -$10 but not any lower
          @balance = (@balance - (amount))
          puts "#{@balance}"
      else
          puts "Nope."
      end




      #*******************
      # The user is allowed three free check uses in one month, but any subsequent use adds a $2 transaction fee
      #reset_checks: Resets the number of checks used to zero
      #*******************
    end



  end


    #***should i try to do constants??? meh.....? ***


    #*** this works with the balance that you get from the csv file....need to test first then implement
    #def get_balance **remember printf("Your balance %.2f",@balance)
    #Money.new(@balance).format
    #end





end



  #OPTIONAL FROM WAVE 1
  # class Owner
  #   attr_accessor :name :address :phone_number
  #
  #   def initialize (name, address, phone_number)
  #     @name = name
  #     @address = address
  #     @phone_number = phone_number
  #
  #   end
  #
  # end



  # TESTS AND STUFF

  #load "BankAccount.rb"

  #test_account = Bank::Account.new(account_hash)


  # my_account = Account.new
  # my_account.create_new(4)

  #1212,1235667,1999-03-27 11:30:09 -0800

  #account_hash = {id:"1212", initial_balance:"1235667", creation_date:"1999-03-27"}

  #my_account = Bank::Account.new(id: 1212, initial_balance: 8)
  #myaccount = Bank::Savings_Account.new(id:1212, initial_balance:20)

  #Bank::Account.new(account_hash)
  #Bank::Account.new(1111, 4000)
  #Bank::Owner.new(Mindy,43rd ave, 8149332710)

  # myaccount = Bank::Savings_Account.new(id:1212, initial_balance:11)
  #Bank::Savings_Account.find(1212)
  #Bank::Savings_Account.all

  #myaccount = Bank::Checking_Account.new(id:1212, initial_balance:20)

  #Bank::Account.all
  #Bank::Account.find(1212)
  #
  # account_hash = {id:"1212", initial_balance:"1235667", creation_date:"1999-03-27"}
  # => {:id=>"1212", :initial_balance=>"1235667", :creation_date=>"1999-03-27"}
  # [3] pry(main)> Bank::Account.new(account_hash)
  # => #<Bank::Account:0x007ffa440260c0 @balance=1235667, @creation_date="1999-03-27", @id=1212>
  # [4] pry(main)> test_account = Bank::Account.new(account_hash)
  # => #<Bank::Account:0x007ffa42a8b440 @balance=1235667, @creation_date="1999-03-27", @id=1212>
  # [5] pry(main)> test_account
  # => #<Bank::Account:0x007ffa42a8b440 @balance=1235667, @creation_date="1999-03-27", @id=1212>
  # [6] pry(main)> test_account.balance
  # => 1235667
  # [7] pry(main)> test_account.withdraw(5000)
  # 1230667





#FAIL:
  #account_hash = {id:"1212", initial_balance:"1235667", creation_date:"1999-03-27"}
# => {:id=>"1212", :initial_balance=>"1235667", :creation_date=>"1999-03-27"}
# [3] pry(main)> Bank::Account.new(account_hash)
# => #<Bank::Account:0x007f9b02824e58 @balance=1235667, @creation_date="1999-03-27", @id=1212>
# [4] pry(main)> test_account = Bank::Account.new(account_hash)
# => #<Bank::Account:0x007f9b03941a10 @balance=1235667, @creation_date="1999-03-27", @id=1212>
# [5] pry(main)> test_account
# => #<Bank::Account:0x007f9b03941a10 @balance=1235667, @creation_date="1999-03-27", @id=1212>
# [6] pry(main)> test_account.withdraw(100)
# 1235567
# => nil
# [7] pry(main)> test_account.deposit(500)
# => 1236067
# [8] pry(main)> test_account.withdraw(1236068)
# Nope.
# => nil
# [9] pry(main)> test_account.balance
# NoMethodError: undefined method `balance' for #<Bank::Account:0x007f9b03941a10>
# from (pry):9:in `__pry__'
