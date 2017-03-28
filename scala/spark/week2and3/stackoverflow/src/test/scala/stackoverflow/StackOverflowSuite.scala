package stackoverflow

import org.scalatest.{FunSuite, BeforeAndAfterAll}
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.spark.rdd.RDD
import java.io.File

import StackOverflow._

@RunWith(classOf[JUnitRunner])
class StackOverflowSuite extends FunSuite with BeforeAndAfterAll {


  lazy val testObject = new StackOverflow {
    override val langs =
      List(
        "JavaScript", "Java", "PHP", "Python", "C#", "C++", "Ruby", "CSS",
        "Objective-C", "Perl", "Scala", "Haskell", "MATLAB", "Clojure", "Groovy")
    override def langSpread = 50000
    override def kmeansKernels = 45
    override def kmeansEta: Double = 20.0D
    override def kmeansMaxIterations = 120
  }

  test("testObject can be instantiated") {
    val instantiatable = try {
      testObject
      true
    } catch {
      case _: Throwable => false
    }
    assert(instantiatable, "Can't instantiate a StackOverflow object")
  }


  test("'rawPostings' should parse csv line into Posting objects with Question") {
    val rdd = sc.parallelize(List("1,101,,,0,Perl"))
    val res = rawPostings(rdd).take(1)
    assert(res(0).postingType == 1)
    assert(res(0).id == 101)
    assert(res(0).acceptedAnswer.getOrElse(0) == 0)
    assert(res(0).parentId == None)
    assert(res(0).score == 0)
    assert(res(0).tags.get == "Perl")
  }


  test("'rawPostings' should parse csv line into Posting objects with Answer") {
    val rdd = sc.parallelize(List("2,201,201,101,0,Perl"))
    val res = rawPostings(rdd).take(1)
    assert(res(0).postingType == 2)
    assert(res(0).id == 201)
    assert(res(0).acceptedAnswer.get == 201)
    assert(res(0).parentId.get == 101)
    assert(res(0).score == 0)
    assert(res(0).tags.get == "Perl")
  }


  test("'extractPostingsByType' extract Question Postings") {
    val question = Posting(postingType = 1,
                          id =             101,
                          acceptedAnswer = None,
                          parentId =       None,
                          score =          0,
                          tags =           Some("Perl"))
    val answer = Posting(postingType = 2,
                        id =             201,
                        acceptedAnswer = None,
                        parentId =       Some(102),
                        score =          0,
                        tags =           Some("Scala"))

    val rdd = sc.parallelize(List(question, answer))
    val result = extractPostingsByType(rdd, 1)
    val res = result.take(1)
    assert(result.count() == 1)
    assert(res(0)._2.postingType == 1)
    assert(res(0)._2.id == 101)
    assert(res(0)._2.acceptedAnswer.isEmpty)
    assert(res(0)._2.parentId.isEmpty)
    assert(res(0)._2.score == 0)
    assert(res(0)._2.tags.get == "Perl")
  }


  test("'extractPostingsByType' extract Answer Postings") {
    val question = Posting(postingType = 1,
                          id =             101,
                          acceptedAnswer = None,
                          parentId =       None,
                          score =          0,
                          tags =           Some("Perl"))
    val answer = Posting(postingType = 2,
                        id =             201,
                        acceptedAnswer = None,
                        parentId =       Some(102),
                        score =          0,
                        tags =           Some("Scala"))

    val rdd = sc.parallelize(List(question, answer))
    val result = extractPostingsByType(rdd, 2)
    val res = result.take(1)
    assert(result.count() == 1)
    assert(res(0)._2.postingType == 2)
    assert(res(0)._2.id == 201)
    assert(res(0)._2.acceptedAnswer.isEmpty)
    assert(res(0)._2.parentId.get == 102)
    assert(res(0)._2.score == 0)
    assert(res(0)._2.tags.get == "Scala")
  }


  test("'groupedPostings' with one question and one answer") {
    val question = Posting(postingType = 1,
                          id = 101,
                          acceptedAnswer = None,
                          parentId = None,
                          score = 0,
                          tags = Some("Perl"))
    val answer = Posting(postingType = 2,
                        id = 201,
                        acceptedAnswer = None,
                        parentId = Some(101),
                        score = 0,
                        tags = Some("Perl"))

    val rdd = sc.parallelize(List(question, answer))
    val result = groupedPostings(rdd)
    val res = result.take(1)
    assert(result.count() == 1)
    assert(res(0)._2.size == 1)
    assert(res(0)._2.head._1.id == 101)
    assert(res(0)._2.head._2.id == 201)
  }


  test("'groupedPostings' with one question and two answers") {
    val question = Posting(postingType = 1,
                          id = 101,
                          acceptedAnswer = None,
                          parentId = None,
                          score = 0,
                          tags = Some("Perl"))
    val answer1 = Posting(postingType = 2,
                        id = 201,
                        acceptedAnswer = None,
                        parentId = Some(101),
                        score = 0,
                        tags = Some("Perl"))
    val answer2 = Posting(postingType = 2,
                        id = 202,
                        acceptedAnswer = None,
                        parentId = Some(101),
                        score = 0,
                        tags = Some("Perl"))

    val rdd = sc.parallelize(List(question, answer1, answer2))
    val result = groupedPostings(rdd)
    val res = result.take(1)
    assert(result.count() == 1)
    assert(res(0)._2.size == 2)
  }


  test("'scoredPostings' get highest score for question") {
    val question = Posting(postingType = 1,
                          id = 101,
                          acceptedAnswer = None,
                          parentId = None,
                          score = 0,
                          tags = Some("Perl"))
    val answer1 = Posting(postingType = 2,
                        id = 201,
                        acceptedAnswer = None,
                        parentId = Some(101),
                        score = 0,
                        tags = Some("Perl"))
    val answer2 = Posting(postingType = 2,
                        id = 202,
                        acceptedAnswer = None,
                        parentId = Some(101),
                        score = 10,
                        tags = Some("Perl"))

    val rdd = sc.parallelize(List(question, answer1, answer2))
    val result = scoredPostings(groupedPostings(rdd))
    val res = result.take(1)
    assert(result.count() == 1)
    assert(res(0)._1.postingType == 1)
    assert(res(0)._1.id == 101)
    assert(res(0)._1.acceptedAnswer.isEmpty)
    assert(res(0)._1.parentId.isEmpty)
    assert(res(0)._1.score == 0)
    assert(res(0)._1.tags.get == "Perl")
    assert(res(0)._2 == 10)
  }


  test("'vectorPostings' vector value for Perl") {
    val question = Posting(postingType = 1,
                          id =             101,
                          acceptedAnswer = None,
                          parentId =       None,
                          score =          0,
                          tags =           Some("Perl"))

    val rdd = sc.parallelize(List((question, 25)))
    val result = vectorPostings(rdd)
    assert(result.count() == 1)
    val res = result.collect()
    assert(res(0)._1 == 450000)
    assert(res(0)._2 == 25)
  }


  test("'vectorPostings' vector value for Scala") {
    val question = Posting(postingType = 1,
                          id =             101,
                          acceptedAnswer = None,
                          parentId =       None,
                          score =          0,
                          tags =           Some("Scala"))

    val rdd = sc.parallelize(List((question, 10)))
    val result = vectorPostings(rdd)
    assert(result.count() == 1)
    val res = result.collect()
    assert(res(0)._1 == 500000)
    assert(res(0)._2 == 10)
  }


  test("'calculateNewMeans' cluster into one group") {
    val vectors = List((1000, 90), (1000, 80))
    val centroids = List((1000, 100), (1000, 10)).toArray

    val rdd = sc.parallelize(vectors)
    val result = calculateNewMeans(rdd, centroids)
    assert(result.length == 1)
    assert(result(0)._1 == 1000)
    assert(result(0)._2 == 85)
  }


  test("'calculateNewMeans' cluster into two groups") {
    val vectors = List((1000, 90), (1000, 80), (2000, 20), (2000,30))
    val centroids = List((1000, 100), (2000, 10)).toArray

    val rdd = sc.parallelize(vectors)
    val result = calculateNewMeans(rdd, centroids)
    assert(result.length == 2)
    result.foreach(f => {
      if (f._1 == 1000) {
        assert(f._2 == 85)
      }
      else if (f._1 == 2000) {
        assert(f._2 == 25)
      }
      else {
        assert(1 == 0)
      }
    })
  }




  test("'getClusterSummary' summaring cluster info") {
    val input = Array((50000, 10), (50000, 20), (100000, 10))

    val result = getClusterSummary(input)

    println(result)

    result.map(f => println("key: " + f._1 + " and array size: " + f._2.size))

//    val res = result.take(1)
//    assert(result.count() == 1)
//    assert(res(0)._2.postingType == 2)
//    assert(res(0)._2.id == 201)
//    assert(res(0)._2.acceptedAnswer.isEmpty)
//    assert(res(0)._2.parentId.get == 102)
//    assert(res(0)._2.score == 0)
//    assert(res(0)._2.tags.get == "Scala")
  }
}
