package wikipedia

import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.SparkContext._
import org.apache.log4j.{Level, Logger}
import scala.util.matching.Regex

import org.apache.spark.rdd.RDD

case class WikipediaArticle(title: String, text: String)

object WikipediaRanking {

  Logger.getLogger("root").setLevel(Level.INFO)
  Logger.getLogger("org").setLevel(Level.WARN)
  Logger.getLogger("akka").setLevel(Level.WARN)

  val langs = List(
    "JavaScript", "Java", "PHP", "Python", "C#", "C++", "Ruby", "CSS",
    "Objective-C", "Perl", "Scala", "Haskell", "MATLAB", "Clojure", "Groovy")

  val conf: SparkConf = new SparkConf().setMaster("local").setAppName("Wiki Programming Languages Ranker")
  val sc: SparkContext = new SparkContext(conf)

  // Hint: use a combination of `sc.textFile`, `WikipediaData.filePath` and `WikipediaData.parse`
  val wikiRdd: RDD[WikipediaArticle] = sc.textFile(WikipediaData.filePath)
                                         .map(s => WikipediaData.parse(s))
                                         .cache()


  /** Returns the number of articles on which the language `lang` occurs.
   *  Hint1: consider using method `aggregate` on RDD[T].
   *  Hint2: should you count the "Java" language when you see "JavaScript"?
   *  Hint3: the only whitespaces are blanks " "
   *  Hint4: no need to search in the title :)
   */
  def occurrencesOfLang(lang: String, rdd: RDD[WikipediaArticle]): Int = {
//    // this is using regex, which is more accurate
//    val regex = ("""\b""" + lang + """\b""").r
//    rdd.filter(w => regex.findFirstIn(w.text).isDefined).count().toInt

    // this using split and contains
    rdd.filter(w => w.text.split(" ").contains(lang)).count().toInt
  }

  /* (1) Use `occurrencesOfLang` to compute the ranking of the languages
   *     (`val langs`) by determining the number of Wikipedia articles that
   *     mention each language at least once. Don't forget to sort the
   *     languages by their occurrence, in decreasing order!
   *
   *   Note: this operation is long-running. It can potentially run for
   *   several seconds.
   */
  def rankLangs(langs: List[String], rdd: RDD[WikipediaArticle]): List[(String, Int)] = {
    langs.map(lang => (lang, occurrencesOfLang(lang, rdd)))
         .sortWith((x, y) => x._2 > y._2)
  }

  /* Compute an inverted index of the set of articles, mapping each language
   * to the Wikipedia pages in which it occurs.
   */
  def makeIndex(langs: List[String], rdd: RDD[WikipediaArticle]): RDD[(String, Iterable[WikipediaArticle])] = {
//    // this is using regex, which is more accurate
//    val regexes = sc.broadcast(langs.map(l => (l -> ("""\b""" + l + """\b""").r)).toMap)
//    val plangs = sc.broadcast(langs)
//    rdd.map(s => (s, plangs.value.filter(l =>
//             regexes.value(l).findFirstIn(s.text).isDefined
//          )))
//       .filter(r => r._2.size > 0)
//       .flatMap(x => x._2.map(l => (l, x._1)))
//       .groupByKey()
//
//
    // this using split and contains
    rdd.map(w => {
          val words = w.text.split(" ")
          (w, langs.filter(l => words.contains(l)))
        })
      .filter(r => r._2.size > 0)
      .flatMap(x => x._2.map(l => (l, x._1)))
      .groupByKey()

  }

  /* (2) Compute the language ranking again, but now using the inverted index. Can you notice
   *     a performance improvement?
   *
   *   Note: this operation is long-running. It can potentially run for
   *   several seconds.
   */
  def rankLangsUsingIndex(index: RDD[(String, Iterable[WikipediaArticle])]): List[(String, Int)] = {
    index.map(x => (x._1, x._2.size))
         .collect()
         .toList
         .sortWith((x, y) => x._2 > y._2)

  }

  /* (3) Use `reduceByKey` so that the computation of the index and the ranking are combined.
   *     Can you notice an improvement in performance compared to measuring *both* the computation of the index
   *     and the computation of the ranking? If so, can you think of a reason?
   *
   *   Note: this operation is long-running. It can potentially run for
   *   several seconds.
   */
  def rankLangsReduceByKey(langs: List[String], rdd: RDD[WikipediaArticle]): List[(String, Int)] = {
//    // this is using regex, which is more accurate
//    val regexes = sc.broadcast(langs.map(l => (l -> ("""\b""" + l + """\b""").r)).toMap)
//    val plangs = sc.broadcast(langs)
//    rdd.map(s => (s, plangs.value.filter(l =>
//            regexes.value(l).findFirstIn(s.text).isDefined
//          )))
//        .filter(r => r._2.size > 0)
//        .flatMap(x => x._2.map(l => (l, 1)))
//        .reduceByKey(_+_)
//        .collect()
//        .toList
//        .sortWith((x, y) => x._2 > y._2)

    // this using split and contains
    rdd.map(w => {
          val words = w.text.split(" ")
          (w, langs.filter(l => words.contains(l)))
        })
      .filter(r => r._2.size > 0)
      .flatMap(x => x._2.map(l => (l, 1)))
      .reduceByKey(_+_)
      .collect()
      .toList
      .sortWith((x, y) => x._2 > y._2)
  }

  def main(args: Array[String]) {

    /* Languages ranked according to (1) */
    val langsRanked: List[(String, Int)] = timed("Part 1: naive ranking", rankLangs(langs, wikiRdd))

    /* An inverted index mapping languages to wikipedia pages on which they appear */
    def index: RDD[(String, Iterable[WikipediaArticle])] = makeIndex(langs, wikiRdd)

    /* Languages ranked according to (2), using the inverted index */
    val langsRanked2: List[(String, Int)] = timed("Part 2: ranking using inverted index", rankLangsUsingIndex(index))

    /* Languages ranked according to (3) */
    val langsRanked3: List[(String, Int)] = timed("Part 3: ranking using reduceByKey", rankLangsReduceByKey(langs, wikiRdd))

    /* Output the speed of each ranking */
//    println(langsRanked)
//    println(langsRanked2)
//    println(langsRanked3)
    println(timing)
    sc.stop()
  }

  val timing = new StringBuffer
  def timed[T](label: String, code: => T): T = {
    val start = System.currentTimeMillis()
    val result = code
    val stop = System.currentTimeMillis()
    timing.append(s"Processing $label took ${stop - start} ms.\n")
    result
  }
}
