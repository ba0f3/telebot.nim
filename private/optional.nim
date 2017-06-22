import json

type
  Optional*[T] = object
    value*: T


proc `&`*[T](v: T): Optional[T] {.inline.} = result.value = v
proc `*`*[T](o: Optional[T]): T {.inline.} = o.value
proc `$`*[T](o: Optional[T]): string {.inline.} = $o.value


proc toOptional*[T](o: var Optional[T], n: JsonNode) {.inline.} =
  when T is int:
    o = &n.num.int
  elif T is string:
    o = &n.str
  elif T is bool:
    o = &n.bval
  else:
    discard

proc getType*[T](o: Optional[T]): typedesc =
  return T



when isMainModule:
  type
    Test = object
      id: int
      name: Optional[string]

  var t: Test
  t.id = 1
  t.name = &"asd"

  echo $t.name
