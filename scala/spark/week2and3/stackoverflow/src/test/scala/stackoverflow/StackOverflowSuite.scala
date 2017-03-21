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
    val rdd = sc.parallelize(List("1,101,,,0,perl"))
    val res = rawPostings(rdd).take(1)
    assert(res(0).postingType == 1)
    assert(res(0).id == 101)
    assert(res(0).acceptedAnswer.getOrElse(0) == 0)
    assert(res(0).parentId == None)
    assert(res(0).score == 0)
    assert(res(0).tags.get == "perl")
  }


  test("'rawPostings' should parse csv line into Posting objects with Answer") {
    val rdd = sc.parallelize(List("2,201,201,101,0,perl"))
    val res = rawPostings(rdd).take(1)
    assert(res(0).postingType == 2)
    assert(res(0).id == 201)
    assert(res(0).acceptedAnswer.get == 201)
    assert(res(0).parentId.get == 101)
    assert(res(0).score == 0)
    assert(res(0).tags.get == "perl")
  }


  test("'extractPostingsByType' extract Question Postings") {
    val question = Posting(postingType = 1,
                          id =             101,
                          acceptedAnswer = None,
                          parentId =       None,
                          score =          0,
                          tags =           Some("perl"))
    val answer = Posting(postingType = 2,
                        id =             201,
                        acceptedAnswer = None,
                        parentId =       Some(102),
                        score =          0,
                        tags =           Some("scala"))

    val rdd = sc.parallelize(List(question, answer))
    val result = extractPostingsByType(rdd, 1)
    val res = result.take(1)
    assert(result.count() == 1)
    assert(res(0)._2.postingType == 1)
    assert(res(0)._2.id == 101)
    assert(res(0)._2.acceptedAnswer.isEmpty)
    assert(res(0)._2.parentId.isEmpty)
    assert(res(0)._2.score == 0)
    assert(res(0)._2.tags.get == "perl")
  }


  test("'extractPostingsByType' extract Answer Postings") {
    val question = Posting(postingType = 1,
                          id =             101,
                          acceptedAnswer = None,
                          parentId =       None,
                          score =          0,
                          tags =           Some("perl"))
    val answer = Posting(postingType = 2,
                        id =             201,
                        acceptedAnswer = None,
                        parentId =       Some(102),
                        score =          0,
                        tags =           Some("scala"))

    val rdd = sc.parallelize(List(question, answer))
    val result = extractPostingsByType(rdd, 2)
    val res = result.take(1)
    assert(result.count() == 1)
    assert(res(0)._2.postingType == 2)
    assert(res(0)._2.id == 201)
    assert(res(0)._2.acceptedAnswer.isEmpty)
    assert(res(0)._2.parentId.get == 102)
    assert(res(0)._2.score == 0)
    assert(res(0)._2.tags.get == "scala")
  }


  test("'groupedPostings' with one question and one answer") {
    val question = Posting(postingType = 1,
                          id = 101,
                          acceptedAnswer = None,
                          parentId = None,
                          score = 0,
                          tags = Some("perl"))
    val answer = Posting(postingType = 2,
                        id = 201,
                        acceptedAnswer = None,
                        parentId = Some(101),
                        score = 0,
                        tags = Some("perl"))

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
                          tags = Some("perl"))
    val answer1 = Posting(postingType = 2,
                        id = 201,
                        acceptedAnswer = None,
                        parentId = Some(101),
                        score = 0,
                        tags = Some("perl"))
    val answer2 = Posting(postingType = 2,
                        id = 202,
                        acceptedAnswer = None,
                        parentId = Some(101),
                        score = 0,
                        tags = Some("perl"))

    val rdd = sc.parallelize(List(question, answer1, answer2))
    val result = groupedPostings(rdd)
    val res = result.take(1)
    assert(result.count() == 1)
    assert(res(0)._2.size == 2)
  }
}
