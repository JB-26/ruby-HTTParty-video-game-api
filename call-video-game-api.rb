#https://mighty-cliffs-81365.herokuapp.com/
require 'httparty'

#new class for the Video Game API hosted on Heroku
class VideoGameAPI
    include HTTParty
    def initialize(username, password)
        @login = {username: username, password: password}.to_json
        #parse response into a hash
        @token = self.class.post('https://mighty-cliffs-81365.herokuapp.com/login', body: @login, :headers => {'Content-Type' => 'application/json'}).parsed_response
        puts "Logged in! Token is: #{@token['access_token']}"
    end

    def displayGames
        #parse response into a hash
        gamesList = self.class.get("https://mighty-cliffs-81365.herokuapp.com/displayGames", :headers => {'Authorization' => "Bearer #{@token['access_token']}"}).parsed_response
        #check if the hash is empty
        if gamesList.empty?
            puts "There are no games in the database!"
        else
            #print each game
            for game in gamesList['Games'] do
                puts "Name: #{game['Game']['Name: ']}\nGenre: #{game['Game']['Genre: ']}\nPlatform: #{game['Game']['Platform: ']}\nPublisher: #{game['Game']['Publisher: ']}\nYear: #{game['Game']['Year']}\n\n"
            end
        end
    end

    def findAGame
        puts "Please enter a search term"
        search = gets.chomp
        puts "You have entered #{search}"

        request = {name: search}.to_json

        response = self.class.get("https://mighty-cliffs-81365.herokuapp.com/findGame", :headers => {'Authorization' => "Bearer #{@token['access_token']}", 'Content-Type' => 'application/json'}, body: request)
        #parse response into a hash
        responseHash = response.parsed_response

        #check if the response is empty
        if response.code == 200
            puts "Search results:"
            for game in responseHash['Games'] do
                puts "Name: #{game['Game']['Name: ']}\nGenre: #{game['Game']['Genre: ']}\nPlatform: #{game['Game']['Platform: ']}\nPublisher: #{game['Game']['Publisher: ']}\nYear: #{game['Game']['Year']}\n\n"
            end
        else
            puts "Couldn't find a game with the term of #{search}!"
        end
    end

    def updateGane
        puts "Enter the ID of the game you want to update"
        id = gets.chomp.to_i
        puts "Enter the field you wish to update (i.e. name, genre)"
        field = gets.chomp.downcase
        puts "Enter the value"
        value = gets.chomp
        puts "You have entered...\nID: #{id}\nField #{field}\nValue: #{value}"

        request = {id: id, field: field, value: value}.to_json

        response = self.class.put("https://mighty-cliffs-81365.herokuapp.com/updateGame", :headers => {'Authorization' => "Bearer #{@token['access_token']}", 'Content-Type' => 'application/json'}, body: request)

        if response.code == 200
            puts "Updated the following:\nName: #{response['Game updated:']['Game']['Name: ']}\nGenre: #{response['Game updated:']['Game']['Genre: ']}\nPlatform: #{response['Game updated:']['Game']['Platform: ']}\nPublisher: #{response['Game updated:']['Game']['Publisher: ']}\nYear: #{response['Game updated:']['Game']['Year']}"
        else
            puts "Failed to update game"
        end
    end

    def deleteGame
        puts "Enter the ID of the game you want to delete"
        id = gets.chomp.to_i

        request = {id:id}.to_json

        #parse response into a hash
        response = self.class.delete("https://mighty-cliffs-81365.herokuapp.com/deleteGame", :headers => {'Authorization' => "Bearer #{@token['access_token']}", 'Content-Type' => 'application/json'}, body: request)
        parsedResponse = response.parsed_response
        
        #check if the response is empty
        if response.code == 200
            puts "The following game has been deleted:\nName: #{parsedResponse['The following has been deleted']['Game']['Name: ']}\nGenre: #{parsedResponse['The following has been deleted']['Game']['Genre: ']}\nPlatform: #{parsedResponse['The following has been deleted']['Game']['Platform: ']}\nPublisher: #{parsedResponse['The following has been deleted']['Game']['Publisher: ']}\nYear: #{parsedResponse['The following has been deleted']['Game']['Year']}"
        else
            puts "No game was found with the ID of #{id}!"
        end
    end

    def addGame
        puts "Enter the name of the game you want to add"
        name = gets.chomp
        puts "Enter the platform"
        platform = gets.chomp
        puts "Enter the publisher"
        publisher = gets.chomp
        puts "Enter the genre"
        genre = gets.chomp
        puts "Enter the year of release"
        year = gets.chomp.to_i

        request = {name: name, platform: platform, publisher: publisher, genre:genre, year:year}.to_json

        response = self.class.post("https://mighty-cliffs-81365.herokuapp.com/addGame", :headers => {'Authorization' => "Bearer #{@token['access_token']}", 'Content-Type' => 'application/json'}, body: request)

        if response.code == 201
            puts "Game added!"
        else
            puts "Failed to add a game to the database!"
        end
    end
end

#main method
def main(videoGameApi)
    while true
        puts "Welcome to the Video Game API CLI tool in Ruby! Please choose an option!"
        puts "1) Display Games\n2) Find a game\n3) Update a game\n4) Delete a game\n5) Add a game\n6) Quit"
        choice = gets.chomp.to_i

        case choice
        when 1
            videoGameApi.displayGames
        when 2
            videoGameApi.findAGame
        when 3
            videoGameApi.updateGane
        when 4
            videoGameApi.deleteGame
        when 5
            videoGameApi.addGame
        when 6
            puts "Goodbye!"
            break
        else
            puts "I don't understand that! Please try again!"
        end
    end
end

puts "Now logging in, please wait...."
puts "NOTE: This application is hosted on Heroku. If this is the first call, it might take some time to retrieve a response."
#create object
videoGameApi = VideoGameAPI.new("Josh", "mypass")
#run main
main(videoGameApi)