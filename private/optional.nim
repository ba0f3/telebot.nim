import json

type
  Optional*[T] = ref object
    value*: T

  OptionalSeq*[T] = ref object
    values: seq[T]

proc wrap*[T](v: T): Optional[T] {.inline.} =
  new(result)
  result.value = v
proc unwrap*[T](o: Optional[T]): T {.inline.} =
  if not o.isNil:
     result = o.value

proc `$`*[T](o: Optional[T]): string {.inline.} =
  if not o.isNil:
    result = $o.value


proc toOptional*[T](o: var Optional[T], n: JsonNode) {.inline.} =
  when T is TelegramObject:
    o.value = unmarshal(n, o.value.type)
  elif T is int:
    o = wrap(n.num.int)
  elif T is string:
    o = wrap(n.str)
  elif T is bool:
    o = wrap(n.bval)
  elif T is seq:
    o.value = @[]
    for item in n.items:
      o.value.put(item)
  elif T is ref:
    o.value = unref(o.value, n)


when isMainModule:
  type
    Test = object
      id: int
      name: Optional[string]

  var t: Test
  t.id = 1
  t.name = &"asd"

  echo $t.name
