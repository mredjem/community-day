# From JAVA to Kotlin

## Qu'est ce que kotlin?

Kotlin est un langage de programation arrivée en 2010. Il a l'avantage d'être polyglote.
Dans la suite de cet article nous allons nous concentrer sur la parralèle entre lui et le JAVA.
Dans un premier temps nous verrons une partie des nouvelles syntaxes qui sont utilisable dans Kotlin.
Et finir par quelques pièges sur lesquels on peut tomber.

## Les nouveautés

### Les getter et setter

Venant d'un monde java vous auriez fait ça :
```
public class Personn{

  private int age;
  private String name;
  
  public int getAge(){
    return this.age;
  }
  public void setAge(int age){
    this.age = age;
  }
  public String getName(){
     return this.name;
  }
  public void setName(String name){
    this.name = name;
  } 

}
```
Assez fastidieux... En kotlin plus besoin de le déclarer (voir le chapitre suivant sur les data class)

Mais imaginons que l'on souhaite avoir un setter un peu plus intelligent, rien de plus simple

```
//la valeur du nom commencera toujours une majuscule.
var name:String
   get() = titi
   set(value) {
      titi = value.capitalize()
   }
```

### Les Data class
Cette pratique est super utile est répond énormément à un bon principe : less code is better.

```
data class Personn(val age: Int, val name:String)
```

Cette ligne de code génère une class avec :

- Constructeur
- getters/setter(si la variable est modifiable , ce qui n'est pas le cas dans l'exemple)
- la methode copy
- la method toString
- le hashCode
- la mathod equals

Ceci à un avantage : lors de l'ajout d'une propriété pas besoin de pensée à ajouter/modifier les méthodes la concernant.


## L'opérateur Elvis

Cette opérateur permet de plus avoir du code qui devient non lisible à cause des tests sur la valeur null.

```
// le caractère '?' spécifie que obj peut être null
fun test( obj : String?){
  // la methode sera appelé seulement si obj est non null
  obj?.toString()
  
  // cette ligne lancera une exception au lancement si obj est null
  obj!!.toString()
  
  //pas besoin de refaire le test  !! car kotlin comprends avec la ligne
  // avec la ligne précédente que arrivé ici obj est forcément non null
  return obj.capitalize()
}

```

### lateinit

```
lateinit var obj:String
```

Celui ci permet de retiré les opérateur !!, kotlin comprends que la variable sera initialisé plus tard.
/!\ Faire attention et être sûr que sa variable sera initialisé sinon on aura la fameuse NPE.


## Le templating de chaîne de caractère

Kotlin a mit en place du templating de string pour simplifier la vie du codeur.

```
val weather = "beau"
print("Lundi il fait $weather, je l'ai vue à la télé")

data class Developper(val name:String){

  fun whoIam() : String{
    return "Je suis $name"
  }

}

val dev = Developper("Bill")
print("Qui êtes vous? ${dev.whoIam()}")

```

## Le mot clé open

Par défaut Kotlin ajout le mot clé final à chaque valeur si open n'est pas spécifié.

## l'héritage en diamand est possible

Il y quelque règle tout de même à respecter , lors de l'implémentation il faut spécifier à kotlin laquelle on utilise.

```
interface  t {
    fun you():String{
        return "t"
    }
}

interface  oi{
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

## Les extensions

Souvent il est utile au developpeur de pouvoir rajouter une petite fonction à une class existante.
En JAVA la méthode est de faire une fonction static qui prends le fameu objet puis applique la modification si il y en a besoin.
Maintenant en kotlin on peut utiliser les extension

```
fun MutableList<Int>.swap(index1 : Int, index2 : Int){
    val tmp = this[index1]
    this[index1] = this[index2]
    this[index2] = tmp
}

var l :MutableList<Int> = mutableListOf(1,2,3)

l.swap(1,2)
```
