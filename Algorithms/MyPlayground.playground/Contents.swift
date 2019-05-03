import UIKit

var str = "Hello, playground"
var genres = [
    "conscious hip hop",
    "nc hip hop",
    "pop rap",
    "rap"
]

for x in genres{
    print(x)
    if(genres.contains(x)){
        print("*")
    }
}
