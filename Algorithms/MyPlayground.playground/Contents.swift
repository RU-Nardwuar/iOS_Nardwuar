import UIKit
import XCPlayground

var str0 = "Hello, playground"
var genres = [
    "conscious hip hop",
    "nc hip hop",
    "pop rap",
    "rap"
]

func grabLongestGenreTag(genres:[String]) -> String{
    var temp = genres[0]
    for index in 0..<genres.count{
        if(genres[index].count > temp.count){
            temp = genres[index]
        }
    }
    return temp
}
print(grabLongestGenreTag(genres: genres))
var following = ["key1": "value1", "key2": "value2"]
var tempGenre:String?

var genreCount = ["pop": 1,
                  "alternative": 1,
                  "rap":1]
print(responseMessages[200])
func countGenresFromAllUsers(){
    
    for (id, name) in following{
        tempGenre = getRequest(id: id)
        print(genreCount)
    }
}

func getRequest(id:String) -> String{
    
    var fakeGenres = ["pop", "hip hop", "alternative", "pop", "alternative", "pop", "pop", "rap", "contemporary"]
    let randomInt = Int.random(in: 0 ..< fakeGenres.count-1)
    return fakeGenres[randomInt]
}
