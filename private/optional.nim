type
  Optional*[T] = object
    data: T

  Test = object
    id: int
    name: Optional[string]
    
proc `$`*[T](v: T): Optional[T] {.inline.} = result.data = v
proc `*`*[T](v: T): Optional[T] {.inline.} = result.data = v
proc `&`*[T](o: Optional[T]): T {.inline.} = o.data
  
when isMainModule:
  var t: Test
  t.id = 1
  t.name = *"asd"

  echo &t.name
