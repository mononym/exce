defmodule ExecsTest do
  import Execs
  use ExUnit.Case, async: true
  doctest Execs

  describe "delete tests:" do
    setup [:setup_context]

    test "delete empty entity", %{id: id} = _context do
      assert transaction(fn -> delete([id]) end) == [%{id: id, components: %{}}]
      assert transaction(fn -> delete(id) end) == %{id: id, components: %{}}
    end

    test "delete nonempty entity", %{id: id} = _context do
      assert transaction(fn -> write(id, [:foo], [:bar], :foobar) end) == id

      assert transaction(fn ->
        delete(id)
      end) == %{id: id, components: %{foo: %{bar: :foobar}}}
    end

    test "delete single component", %{id: id} = _context do
      transaction(fn ->
        write([id], [:foo, :bar], [:foo, :bar], :foobar)
      end)

      assert transaction(fn ->
        delete(id, [:bar])
      end) == %{id: id, components: %{bar: %{foo: :foobar, bar: :foobar}}}

      assert transaction(fn ->
        read(id)
      end) == %{id: id, components: %{foo: %{bar: :foobar, foo: :foobar}}}
    end

    test "delete single key", %{id: id} = _context do
      transaction(fn ->
        write([id], [:foo, :bar], [:foo, :bar], :foobar)
      end)

      assert transaction(fn ->
        delete(id, [:bar], [:foo])
      end) == %{id: id, components: %{bar: %{foo: :foobar}}}

      assert transaction(fn ->
        read([id])
      end) == [
        %{id: id,
          components: %{foo: %{bar: :foobar, foo: :foobar},
                        bar: %{bar: :foobar}}}
      ]
    end
  end

  describe "has* tests:" do
      setup [:setup_context]

      test "has_all", %{id: id} = _context do
        id2 = new_entity()

        transaction(fn ->
          write([id, id2], [:foo, :bar], [:foo, :bar], :foobar)
          write([id], [:foobar], [:foo], :foobar)
        end)

        assert transaction(fn ->
          has_all(id, [:bar])
        end) == true

        assert transaction(fn ->
          has_all(id, [:bar, :foo])
        end) == true

        assert transaction(fn ->
          has_all([id, id2], [:bar, :foo])
        end) == [%{id: id, result: true}, %{id: id2, result: true}]

        assert transaction(fn ->
          has_all([id, id2], [:bar, :foo, :foobar])
        end) == [%{id: id, result: true}, %{id: id2, result: false}]

        assert transaction(fn ->
          has_all([id, id2], [:bar, :foo, :foobar], [:foo, :bar, :foobar])
        end) == [%{id: id, result: false}, %{id: id2, result: false}]

        assert transaction(fn ->
          has_all([id, id2], [:bar, :foo], [:foo, :bar])
        end) == [%{id: id, result: true}, %{id: id2, result: true}]

        assert transaction(fn ->
          has_all([id, id2],
                  [:bar, :foo],
                  [:foo, :bar],
                  [&(&1 === :foobar), fn(_) -> true end])
        end) == [%{id: id, result: true}, %{id: id2, result: true}]

        assert transaction(fn ->
          has_all([id, id2],
                  [:bar, :foo],
                  [:foo, :bar],
                  [&(&1 === :foobar), fn(_) -> false end])
        end) == [%{id: id, result: false}, %{id: id2, result: false}]
      end

      test "has_any", %{id: id} = _context do
        id2 = new_entity()

        transaction(fn ->
          write([id], [:foo, :bar, :foobar], [:bar], :foobar)
          write([id2], [:foo, :bar], [:bar], :foobar)
        end)

        assert transaction(fn ->
          has_any(id, [:bar])
        end) == true

        assert transaction(fn ->
          has_any(id, [:bar, :baz])
        end) == true

        assert transaction(fn ->
          has_any(id, [:baz])
        end) == false

        assert transaction(fn ->
          has_any([id, id2], [:bar, :baz])
        end) == [%{id: id, result: true}, %{id: id2, result: true}]

        assert transaction(fn ->
          has_any([id, id2], [:foobar])
        end) == [%{id: id, result: true}, %{id: id2, result: false}]

        assert transaction(fn ->
          has_any([id, id2], [:foobar], [:bar])
        end) == [%{id: id, result: true}, %{id: id2, result: false}]

        assert transaction(fn ->
          has_any([id, id2],
                  [:foobar],
                  [:bar],
                  [&(&1 === :foobar), fn(_) -> true end])
        end) == [%{id: id, result: true}, %{id: id2, result: false}]
      end

      test "has_which", %{id: id} = _context do
        id2 = new_entity()

        transaction(fn ->
          write([id], [:foo, :bar, :foobar], [:bar], :foobar)
          write([id2], [:foo, :bar], [:bar], :foobar)
        end)

        assert transaction(fn ->
          has_which(id, [:bar])
        end) == %{id: id, components: %{bar: true}}

        assert transaction(fn ->
          has_which(id, [:oof])
        end) == %{id: id, components: %{oof: false}}

        assert transaction(fn ->
          has_which(id, [:bar, :oof])
        end) == %{id: id, components: %{oof: false, bar: true}}

        assert transaction(fn ->
          has_which([id, id2], [:bar, :oof])
        end) == [%{id: id, components: %{oof: false, bar: true}}, %{id: id2, components: %{oof: false, bar: true}}]

        assert transaction(fn ->
          has_which([id, id2], [:bar, :oof], [:bar, :foo])
        end) == [
          %{id: id,
            components: %{bar: %{bar: true, foo: false},
                          oof: %{bar: false, foo: false}}},
          %{id: id2,
            components: %{bar: %{bar: true, foo: false},
                          oof: %{bar: false, foo: false}}}
        ]

        assert transaction(fn ->
          has_which([id, id2],
                    [:foo, :bar],
                    [:bar, :foo],
                    [&(&1 === :foobar), fn(_) -> true end])
        end) == [
          %{id: id,
            components: %{bar: %{bar: true, foo: false},
                          foo: %{bar: true, foo: false}}},
          %{id: id2,
            components: %{bar: %{bar: true, foo: false},
                          foo: %{bar: true, foo: false}}}
        ]
      end
    end

  describe "list tests:" do
    setup [:setup_context]

    test "list", %{id: id} = _context do
      id2 = new_entity()

      transaction(fn ->
        write([id, id2], [:foo, :bar], [:bar, :foo], :foobar)
      end)

      assert transaction(fn ->
        list(id)
      end) == %{id: id, components: [:bar, :foo]}

      assert transaction(fn ->
        list([id, id2], [:foo, :bar])
      end) == [
        %{id: id,
          components: %{bar: [:bar, :foo],
                        foo: [:bar, :foo]}},
        %{id: id2,
          components: %{bar: [:bar, :foo],
                        foo: [:bar, :foo]}}
      ]
    end
  end

  describe "find* tests:" do
    setup [:setup_context]

    test "find_with_all", %{id: id} = _context do
      id2 = new_entity()

      transaction(fn ->
        write([id, id2], [:oof, :rab], [:oof, :rab], :raboof)
      end)

      assert transaction(fn ->
        find_with_all([:oof, :rab])
      end) == [id, id2]

      assert transaction(fn ->
        find_with_all([:oof, :rabbar])
      end) == []

      assert transaction(fn ->
        find_with_all([:oof, :rab], [:oof, :rab])
      end) == [id, id2]

      assert transaction(fn ->
        find_with_all([:oof, :rab], [:oof, :rabbar])
      end) == []

      assert transaction(fn ->
        find_with_all([:oof, :rab],
                      [:oof, :rab],
                      [&(&1 === :raboof), fn(_) -> true end])
      end) == [id, id2]

      assert transaction(fn ->
        find_with_all([:oof, :rab],
                      [:oof, :rab],
                      [&(&1 === :foobar), fn(_) -> true end])
      end) == []
    end

      test "find_with_any", %{id: id} = _context do
        id2 = new_entity()

        transaction(fn ->
          write([id, id2], [:blarg, :blarb], [:blarg, :blarb], :meepmeep)
        end)

        assert transaction(fn ->
          find_with_any([:blarg, :glarb])
        end) == [id, id2]

        assert transaction(fn ->
          find_with_any([:glarb])
        end) == []

        assert transaction(fn ->
          find_with_any([:blarg, :glarb], [:blarg, :glarb])
        end) == [id, id2]

        assert transaction(fn ->
          find_with_any([:blarg, :glarb],
                        [:blarg, :glarb],
                        [&(&1 === :raboof), fn(_) -> true end])
        end) == [id, id2]

        assert transaction(fn ->
          find_with_any([:blarg, :glarb],
                        [:blarg, :glarb],
                        [&(&1 === :foobar)])
        end) == []
      end
    end

  describe "read tests:" do
    setup [:setup_context]

    test "read", %{id: id} = _context do
      id2 = new_entity()

      assert transaction(fn ->
        write([id, id2], [:foo, :bar], [:foo, :bar], :foobar)
      end) == [id, id2]

      assert transaction(fn ->
        read([id, id2])
      end) == [
          %{id: id,
           components: %{foo: %{bar: :foobar, foo: :foobar},
                         bar: %{bar: :foobar, foo: :foobar}}},
          %{id: id2,
            components: %{foo: %{bar: :foobar, foo: :foobar},
                          bar: %{bar: :foobar, foo: :foobar}}}
        ]

      assert transaction(fn ->
        read([id, id2], [:foo, :bar])
      end) == [
        %{id: id,
          components: %{foo: %{bar: :foobar, foo: :foobar},
                        bar: %{bar: :foobar, foo: :foobar}}},
        %{id: id2,
          components: %{foo: %{bar: :foobar, foo: :foobar},
                        bar: %{bar: :foobar, foo: :foobar}}}
      ]

      assert transaction(fn ->
        read([id, id2], [:foo, :bar], [:foo, :bar])
      end) ==[
        %{id: id,
          components: %{foo: %{bar: :foobar, foo: :foobar},
                        bar: %{bar: :foobar, foo: :foobar}}},
        %{id: id2,
          components: %{foo: %{bar: :foobar, foo: :foobar},
                        bar: %{bar: :foobar, foo: :foobar}}}
      ]

      assert transaction(fn ->
        read(id, [:foo, :bar], [:foo])
      end) ==
        %{id: id,
          components: %{foo: %{foo: :foobar},
                        bar: %{foo: :foobar}}}

      assert transaction(fn ->
        read(id, [:foo], [:foo, :bar])
      end) ==
        %{id: id,
          components: %{foo: %{bar: :foobar, foo: :foobar}}}

      assert transaction(fn ->
        read(id, :foo, :foo)
      end) == :foobar
    end
  end

  describe "write tests:" do
    setup [:setup_context]

    test "write", %{id: id} = _context do
      id2 = new_entity()

      assert transaction(fn ->
        write(id, [:foo], [:bar], :foobar)
      end) == id

      assert transaction(fn ->
        write([id, id2], [:foo], [:bar], :foobar)
      end) == [id, id2]

      assert transaction(fn ->
        write([id, id2], [:foo, :bar], [:bar, :foo], :foobar)
      end) == [id, id2]

      assert transaction(fn ->
        read([id, id2])
      end) == [
        %{id: id,
          components: %{foo: %{bar: :foobar, foo: :foobar},
                        bar: %{bar: :foobar, foo: :foobar}}},
        %{id: id2,
          components: %{foo: %{bar: :foobar, foo: :foobar},
                        bar: %{bar: :foobar, foo: :foobar}}}
      ]

    end
  end

  defp setup_context(_context) do
    %{id: new_entity()}
  end

  defp new_entity do
    create()
  end
end
