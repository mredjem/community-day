# From JAVA to Kotlin

## Qu'est ce que kotlin?

Kotlin est un langage de programmation arrivé en 2010. Il a l'avantage d'être polyglote.

Au cours de ce post, nous allons nous concentrer sur le parralèle entre lui et Java. Dans un premier temps nous verrons une partie des nouvelles syntaxes qui sont utilisables dans Kotlin. et finir par quelques pièges sur lesquels on peut tomber.

## Les nouveautés

### Les getter et setter

Venant d'un monde java vous auriez fait ça :

```java
public class Person {

  private int age;

  private String name;

  public int getAge() {
    return this.age;
  }

  public void setAge(int age) {
    this.age = age;
  }

  public String getName() {
     return this.name;
  }

  public void setName(String name) {
    this.name = name;
  }

}
```

Assez fastidieux... En kotlin plus besoin de les déclarer (voir le chapitre suivant sur les data class)

Mais imaginons que l'on souhaite avoir un setter un peu plus intelligent, rien de plus simple:

```kotlin
// la valeur du nom commencera toujours une majuscule.
var name:String
  get() = titi
  set(value) {
    titi = value.capitalize()
  }
```

### Les Data class

Cette pratique est super utile et elle répond à un principe de base : **less code is better**.

```kotlin
data class Person(val age: Int, val name:String)
```

Cette ligne de code génère une class avec :

- un constructeur
- des getters, voire des setters si la variable est modifiable (_ce qui n'est pas le cas dans l'exemple_)
- la méthode `copy()`
- la méthode `toString()`
- la méthode `hashCode()`
- la méthode `equals()`

Ceci à un avantage : lors de l'ajout d'une propriété pas besoin de penser à ajouter/modifier les méthodes la concernant.

### L'opérateur Elvis

Cette opérateur permet d'obtenir un code plus lisible en faisant disparaître les conditions sur la valeur `null` (the Billion Dollar Mistake).

```kotlin
// le caractère '?' spécifie que obj peut être null
fun test( obj : String?) {
  // la methode sera appelée seulement si obj est non null
  obj?.toString()

  // cette ligne lancera une exception au lancement si obj est null
  obj!!.toString()

  //pas besoin de refaire le test !! car kotlin comprend avec la ligne précédente qu'à cette endroit obj est forcément non null
  return obj.capitalize()
}
```

### Le lateinit

```kotlin
lateinit var obj:String
```

Ce mot clé permet de retirer les opérateurs !!, kotlin comprend que la variable sera initialisée plus tard.

> Faire attention et être sûr que sa variable sera initialisée sinon on aura la fameuse NPE.


### Le templating de chaînes de caractères

Kotlin a mit en place du templating de string pour simplifier la vie du codeur.

```kotlin
val weather = "beau"
print("Lundi il fait $weather, je l'ai vu à la télé")

data class Developper(val name:String) {
  fun whoAmI() : String{
    return "Je suis $name"
  }
}

val dev = Developper("Bill")
print("Qui êtes vous? ${dev.whoAmI()}")
```

### Le mot clé open

Par défaut Kotlin ajoute le mot clé `final` à chaque valeur si `open` n'est pas spécifié.

### L'héritage en diamant

Il y quelques règles tout de même à respecter, lors de l'implémentation il faut spécifier à kotlin laquelle on utilise.

```kotlin
interface  t {
  fun you():String {
    return "t"
  }
}

interface  oi {
  fun you():String{
    return "oi"
  }
}


class toi : t,oi {
  override fun you(): String {
    return "${super<t>.you()}${super<oi>.you()}"
  }
}
```

### Les extensions

Souvent il est utile au développeur de pouvoir rajouter une petite fonction à une classe existante.

En JAVA une possibilité est de créer une fonction statique qui prend le fameux objet puis applique la modification s'il y en a besoin.

Maintenant en kotlin on peut utiliser les extensions:

```kotlin
fun MutableList<Int>.swap(index1 : Int, index2 : Int) {
  val tmp = this[index1]
  this[index1] = this[index2]
  this[index2] = tmp
}

var l :MutableList<Int> = mutableListOf(1,2,3)

l.swap(1,2)
```

### Le mot clé object

Ce mot clé nous permet de créer des singleton dans kotlin.

```kotlin
object State {
  var value : String = "init"
}

fun launch() {
  State.value = "launch"
  //...
}
```

### Les coroutines

Pour parler de cette fonctionnalité je vais partager un [article](https://blog.link-value.fr/les-coroutines-dans-kotlin-concepts-et-manipulation-2869e6415e6d) super bien écrit.

## Astuces

Pour une meilleure compréhension de Kotlin une astuce simple à réaliser et de transformer le code kotlin en byte code pour ensuite le transformer en Java pour analyse.

Et pour ça un bon petit [article](https://medium.com/@mydogtom/tip-how-to-show-java-equivalent-for-kotlin-code-f7c81d76fa8).
