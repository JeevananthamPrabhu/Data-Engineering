object Hi{
def main(args:Array[String])={
var a=List("Ram","Ravi","Saran")
print(a.groupBy(x=>x).view.mapValues(_.size).toMap)
}}