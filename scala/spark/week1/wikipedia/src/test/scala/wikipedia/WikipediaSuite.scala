package wikipedia

import org.scalatest.{FunSuite, BeforeAndAfterAll}
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._

@RunWith(classOf[JUnitRunner])
class WikipediaSuite extends FunSuite with BeforeAndAfterAll {

  def initializeWikipediaRanking(): Boolean =
    try {
      WikipediaRanking
      true
    } catch {
      case ex: Throwable =>
        println(ex.getMessage)
        ex.printStackTrace()
        false
    }

  override def afterAll(): Unit = {
    assert(initializeWikipediaRanking(), " -- did you fill in all the values in WikipediaRanking (conf, sc, wikiRdd)?")
    import WikipediaRanking._
    sc.stop()
  }

  // Conditions:
  // (1) the language stats contain the same elements
  // (2) they are ordered (and the order doesn't matter if there are several languages with the same count)
  def assertEquivalentAndOrdered(given: List[(String, Int)], expected: List[(String, Int)]): Unit = {
    // (1)
    assert(given.toSet == expected.toSet, "The given elements are not the same as the expected elements")
    // (2)
    assert(
      !(given zip given.tail).exists({ case ((_, occ1), (_, occ2)) => occ1 < occ2 }),
      "The given elements are not in descending order"
    )
  }

  test("'occurrencesOfLang' should work for (specific) RDD with one element") {
    assert(initializeWikipediaRanking(), " -- did you fill in all the values in WikipediaRanking (conf, sc, wikiRdd)?")
    import WikipediaRanking._
    val rdd = sc.parallelize(Seq(WikipediaArticle("title", "Java Jakarta"),
                                 WikipediaArticle("title", "JavaScript"),
                                 WikipediaArticle("title", "Java Guava")))
    assert(occurrencesOfLang("Java", rdd) == 2,
           "occurrencesOfLang given (specific) RDD with one element should equal to 2")
    assert(occurrencesOfLang("JavaScript", rdd) == 1,
           "occurrencesOfLang given (specific) RDD with one element should equal to 1")
  }

  test("'rankLangs' should work for RDD with two elements") {
    assert(initializeWikipediaRanking(), " -- did you fill in all the values in WikipediaRanking (conf, sc, wikiRdd)?")
    import WikipediaRanking._
    val langs = List("Scala", "Java", "Perl")
    val rdd = sc.parallelize(List(WikipediaArticle("1", "Scala is great"),
                                  WikipediaArticle("2", "Java is OK, but Scala is cooler"),
                                  WikipediaArticle("3", "Perl is the best"),
                                  WikipediaArticle("4", "Perl is awesome"),
                                  WikipediaArticle("5", "Perl wins!")))
    val ranked = rankLangs(langs, rdd)
    assert(ranked(0)._1 == "Perl")
    assert(ranked(1)._1 == "Scala")
    assert(ranked(2)._1 == "Java")
  }

  test("'makeIndex' creates a simple index with two entries") {
    assert(initializeWikipediaRanking(), " -- did you fill in all the values in WikipediaRanking (conf, sc, wikiRdd)?")
    import WikipediaRanking._
    val langs = List("Scala", "Java", "Perl")
    val articles = List(
        WikipediaArticle("1","Groovy is pretty interesting, and so is Erlang"),
        WikipediaArticle("2","Scala and Java run on the JVM"),
        WikipediaArticle("3","Scala is not purely functional")
      )
    val rdd = sc.parallelize(articles)
    val index = makeIndex(langs, rdd)
    assert(index.count() == 2)
  }

  test("'rankLangsUsingIndex' should work for a simple RDD with three elements") {
    assert(initializeWikipediaRanking(), " -- did you fill in all the values in WikipediaRanking (conf, sc, wikiRdd)?")
    import WikipediaRanking._
    val langs = List("Scala", "Java", "Perl")
    val articles = List(
        WikipediaArticle("1","Groovy is pretty interesting, and so is Erlang"),
        WikipediaArticle("2","Scala and Java run on the JVM"),
        WikipediaArticle("3","Scala is not purely functional"),
        WikipediaArticle("3", "Perl is the best"),
        WikipediaArticle("4", "Perl is awesome"),
        WikipediaArticle("5", "Perl wins!")
      )
    val rdd = sc.parallelize(articles)
    val index = makeIndex(langs, rdd)
    val ranked = rankLangsUsingIndex(index)
    assert(ranked(0)._1 == "Perl")
    assert(ranked(1)._1 == "Scala")
    assert(ranked(2)._1 == "Java")
  }

  test("'rankLangsReduceByKey' should work for a simple RDD with four elements") {
    assert(initializeWikipediaRanking(), " -- did you fill in all the values in WikipediaRanking (conf, sc, wikiRdd)?")
    import WikipediaRanking._
    val langs = List("Scala", "Java", "Groovy", "Haskell", "Erlang")
    val articles = List(
        WikipediaArticle("1","Groovy is pretty interesting, and so is Erlang"),
        WikipediaArticle("2","Scala and Java run on the JVM"),
        WikipediaArticle("3","Scala is not purely functional"),
        WikipediaArticle("4","The cool kids like Haskell more than Java"),
        WikipediaArticle("5","Java is for enterprise developers")
      )
    val rdd = sc.parallelize(articles)
    val ranked = rankLangsReduceByKey(langs, rdd)
    assert(ranked(0)._1 == "Java")
    assert(ranked(1)._1 == "Scala")
  }


}