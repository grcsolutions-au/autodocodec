{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE OverloadedLists #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE TypeApplications #-}

module Autodocodec.OpenAPISpec (spec) where

import Autodocodec
import Autodocodec.OpenAPI
import Autodocodec.OpenAPI.DerivingVia
import Autodocodec.Usage
import qualified Data.Aeson as JSON
import Data.DList (DList)
import Data.DList.DNonEmpty (DNonEmpty)
import Data.Data
import Data.Functor.Const (Const)
import Data.Functor.Identity (Identity)
import Data.GenValidity.Aeson ()
import Data.GenValidity.Containers ()
import Data.GenValidity.Scientific ()
import Data.GenValidity.Text ()
import Data.GenValidity.Time ()
import Data.Int
import Data.List.NonEmpty (NonEmpty)
import Data.Map (Map)
import Data.Maybe
import qualified Data.Monoid as Monoid
import Data.OpenApi (Components (..), OpenApi (..))
import qualified Data.OpenApi as OpenAPI
import qualified Data.OpenApi.Declare as OpenAPI
import Data.Scientific
import Data.Semigroup (Dual)
import qualified Data.Semigroup as Semigroup
import Data.Set (Set)
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.Lazy as LT
import Data.Time
import Data.UUID.Types (UUID)
import Data.Vector (Vector)
import Data.Void
import Data.Word
import Numeric.Natural
import Test.Syd
import Test.Syd.Aeson
import Test.Syd.Validity.Utils

openAPISchemaSpecAndViaDeclareSchemaRef :: forall a. (Typeable a, HasCodec a) => FilePath -> Spec
openAPISchemaSpecAndViaDeclareSchemaRef filePath = do
  openAPISchemaSpec @a filePath
  openAPISchemaSpecViaDeclareSchemaRef @a filePath

spec :: Spec
spec = do
  openAPISchemaSpec @NullUnit "null"
  openAPISchemaSpecViaDeclareSchemaRef @NullUnit "null"
  openAPISchemaSpec @Void "void"
  openAPISchemaSpecViaDeclareSchemaRef @Void "void"
  openAPISchemaSpec @(Either Void Bool) "either-void-bool"
  openAPISchemaSpec @Bool "bool"
  openAPISchemaSpec @Ordering "ordering"
  openAPISchemaSpec @Char "char"
  openAPISchemaSpec @Text "text"
  openAPISchemaSpec @LT.Text "lazy-text"
  openAPISchemaSpec @String "string"
  openAPISchemaSpec @StringWithBounds "string-with-bounds"
  openAPISchemaSpec @Scientific "scientific"
  openAPISchemaSpec @JSON.Object "object"
  openAPISchemaSpec @JSON.Value "value"
  openAPISchemaSpec @Int "int"
  openAPISchemaSpec @Int8 "int8"
  openAPISchemaSpec @Int16 "int16"
  openAPISchemaSpec @Int32 "int32"
  openAPISchemaSpec @Int64 "int64"
  openAPISchemaSpec @Integer "integer"
  openAPISchemaSpec @Word "word"
  openAPISchemaSpec @Word8 "word8"
  openAPISchemaSpec @Word16 "word16"
  openAPISchemaSpec @Word32 "word32"
  openAPISchemaSpec @Word64 "word64"
  openAPISchemaSpec @Natural "natural"
  openAPISchemaSpec @(Maybe Text) "maybe-text"
  openAPISchemaSpec @(Either Bool Text) "either-bool-text"
  openAPISchemaSpec @(Either (Either Bool Scientific) Text) "either-either-bool-scientific-text"
  openAPISchemaSpec @(Vector Text) "vector-text"
  openAPISchemaSpec @[Text] "list-text"
  openAPISchemaSpec @(DList Text) "dlist-text"
  openAPISchemaSpec @(NonEmpty Text) "nonempty-text"
  openAPISchemaSpec @(DNonEmpty Text) "dnonempty-text"
  openAPISchemaSpec @(Set Text) "set-text"
  openAPISchemaSpec @(Map Text Int) "map-text-int"
  openAPISchemaSpec @Day "day"
  openAPISchemaSpec @LocalTime "local-time"
  openAPISchemaSpec @UTCTime "utc-time"
  openAPISchemaSpec @TimeOfDay "time-of-day"
  xdescribe "doesn't hold" $ openAPISchemaSpec @ZonedTime "zoned-time"
  openAPISchemaSpec @DiffTime "difftime"
  openAPISchemaSpec @NominalDiffTime "nominal-difftime"
  openAPISchemaSpecAndViaDeclareSchemaRef @UUID "uuid"
  openAPISchemaSpec @Fruit "fruit"
  openAPISchemaSpecViaDeclareSchemaRef @Fruit "fruit"
  openAPISchemaSpec @Shape "shape"
  openAPISchemaSpecViaDeclareSchemaRef @Shape "shape"
  openAPISchemaSpec @Example "example"
  openAPISchemaSpecViaDeclareSchemaRef @Example "example"
  openAPISchemaSpec @Derived "derived"
  openAPISchemaSpecViaDeclareSchemaRef @Derived "derived"
  openAPISchemaSpec @ListsExample "lists-example"
  openAPISchemaSpecViaDeclareSchemaRef @ListsExample "lists-example"
  openAPISchemaSpec @OptionalFields "optional-fields"
  openAPISchemaSpecViaDeclareSchemaRef @OptionalFields "optional-fields"
  openAPISchemaSpec @Recursive "recursive"
  openAPISchemaSpecViaDeclareSchemaRef @Recursive "recursive"
  openAPISchemaSpec @MutuallyRecursiveA "mutually-recursive"
  openAPISchemaSpecViaDeclareSchemaRef @MutuallyRecursiveA "mutually-recursive"
  openAPISchemaSpec @Via "via"
  openAPISchemaSpecViaDeclareSchemaRef @Via "via"
  openAPISchemaSpec @VeryComment "very-comment"
  openAPISchemaSpecViaDeclareSchemaRef @VeryComment "very-comment"
  openAPISchemaSpec @LegacyValue "legacy-value"
  openAPISchemaSpecViaDeclareSchemaRef @LegacyValue "legacy-value"
  openAPISchemaSpec @LegacyObject "legacy-object"
  openAPISchemaSpecViaDeclareSchemaRef @LegacyObject "legacy-object"
  openAPISchemaSpec @Ainur "ainur"
  openAPISchemaSpecViaDeclareSchemaRef @Ainur "ainur"
  openAPISchemaSpec @War "war"
  openAPISchemaSpecViaDeclareSchemaRef @War "war"
  openAPISchemaSpec @These "these"
  openAPISchemaSpecViaDeclareSchemaRef @These "these"
  openAPISchemaSpec @Expression "expression"
  openAPISchemaSpecViaDeclareSchemaRef @Expression "expression"
  openAPISchemaSpecAndViaDeclareSchemaRef @(Identity Text) "identity"
  openAPISchemaSpecAndViaDeclareSchemaRef @(Dual Text) "dual"
  openAPISchemaSpecAndViaDeclareSchemaRef @(Semigroup.First Text) "semigroup-first"
  openAPISchemaSpecAndViaDeclareSchemaRef @(Semigroup.Last Text) "semigroup-last"
  openAPISchemaSpecAndViaDeclareSchemaRef @(Monoid.First Text) "monoid-first"
  openAPISchemaSpecAndViaDeclareSchemaRef @(Monoid.Last Text) "monoid-last"
  openAPISchemaSpecAndViaDeclareSchemaRef @(Const Text Void) "const"
  openAPISchemaSpec @Overlap "overlap"
  -- Not covered because openapi3 has no 'OpenAPI.ToSchema' instance for them:
  -- Ordering, JSON.Value, Monoid.First, Monoid.Last, Const, DiffTime
  describe "ToSchema equivalence" $ do
    -- Primitives and numerics
    openAPIToSchemaEquivalenceSpec @Bool
    openAPIToSchemaEquivalenceSpec @Char
    openAPIToSchemaEquivalenceSpec @Text
    openAPIToSchemaEquivalenceSpec @LT.Text
    openAPIToSchemaEquivalenceSpec @String
    openAPIToSchemaEquivalenceSpec @Scientific
    -- Matching this needs changes to how 'HashMapCodec' is named and rendered.
    xdescribe "doesn't hold: codec is unnamed, has additionalProperties and no description" $
      openAPIToSchemaEquivalenceSpec @JSON.Object
    openAPIToSchemaEquivalenceSpec @Int
    openAPIToSchemaEquivalenceSpec @Int8
    openAPIToSchemaEquivalenceSpec @Int16
    openAPIToSchemaEquivalenceSpec @Int32
    openAPIToSchemaEquivalenceSpec @Int64
    openAPIToSchemaEquivalenceSpec @Integer
    openAPIToSchemaEquivalenceSpec @Word
    openAPIToSchemaEquivalenceSpec @Word8
    openAPIToSchemaEquivalenceSpec @Word16
    openAPIToSchemaEquivalenceSpec @Word32
    openAPIToSchemaEquivalenceSpec @Word64
    -- The default, 'False', so both schemas mean the same thing.
    xdescribe "doesn't hold: codec lacks exclusiveMinimum False" $
      openAPIToSchemaEquivalenceSpec @Natural
    -- Containers and wrappers
    -- The codec does accept null, so its schema is the accurate one.
    xdescribe "doesn't hold: codec sets nullable True" $
      openAPIToSchemaEquivalenceSpec @(Maybe Text)
    -- Naming it like openapi3 does would need Typeable constraints on the instance.
    xdescribe "doesn't hold: codec is unnamed" $
      openAPIToSchemaEquivalenceSpec @(Either Bool Text)
    openAPIToSchemaEquivalenceSpec @[Text]
    openAPIToSchemaEquivalenceSpec @(Vector Text)
    openAPIToSchemaEquivalenceSpec @(NonEmpty Text)
    -- The codec removes duplicates instead of rejecting them, so this would
    -- document a check that decoding doesn't do.
    xdescribe "doesn't hold: codec lacks uniqueItems True" $
      openAPIToSchemaEquivalenceSpec @(Set Text)
    openAPIToSchemaEquivalenceSpec @(Map Text Int)
    openAPIToSchemaEquivalenceSpec @(Identity Text)
    openAPIToSchemaEquivalenceSpec @(Dual Text)
    openAPIToSchemaEquivalenceSpec @(Semigroup.First Text)
    openAPIToSchemaEquivalenceSpec @(Semigroup.Last Text)
    -- Time
    openAPIToSchemaEquivalenceSpec @Day
    openAPIToSchemaEquivalenceSpec @LocalTime
    openAPIToSchemaEquivalenceSpec @UTCTime
    openAPIToSchemaEquivalenceSpec @TimeOfDay
    openAPIToSchemaEquivalenceSpec @ZonedTime
    openAPIToSchemaEquivalenceSpec @NominalDiffTime
    -- Other
    openAPIToSchemaEquivalenceSpec @UUID

-- | Check that the 'OpenAPI.ToSchema' instance that is defined for @a@ outside
-- of autodocodec produces exactly the same output as the codec-based one.
openAPIToSchemaEquivalenceSpec ::
  forall a.
  (HasCodec a, OpenAPI.ToSchema a) =>
  Spec
openAPIToSchemaEquivalenceSpec =
  describe ("openAPIToSchemaEquivalenceSpec @" <> nameOf @a) $ do
    it "has the same declareNamedSchema" $
      let native = OpenAPI.runDeclare (OpenAPI.declareNamedSchema (Proxy :: Proxy a)) mempty
          viaCodec = OpenAPI.runDeclare (declareNamedSchemaViaCodec (Proxy :: Proxy a)) mempty
       in viaCodec `shouldBe` native
    it "has the same declareSchemaRef" $
      let native = OpenAPI.runDeclare (OpenAPI.declareSchemaRef (Proxy :: Proxy a)) mempty
          viaCodec = OpenAPI.runDeclare (OpenAPI.declareSchemaRef (Proxy :: Proxy (AutodocodecOpenApi a))) mempty
       in viaCodec `shouldBe` native

openAPISchemaSpec :: forall a. (Typeable a, HasCodec a) => FilePath -> Spec
openAPISchemaSpec filePath =
  describe ("openAPISchemaSpec @" <> nameOf @a) $ do
    let (definitions, _) = flip OpenAPI.runDeclare mempty $ do
          OpenAPI.NamedSchema mName schema <- declareNamedSchemaViaCodec (Proxy :: Proxy a)
          OpenAPI.declare [(fromMaybe (T.pack $ nameOf @a) mName, schema)]
          pure schema
    it "outputs the same schema as before" $
      let openAPI = mempty {_openApiComponents = mempty {_componentsSchemas = definitions}}
       in pureGoldenJSONFile
            ("test_resources/openapi-schema/" <> filePath <> ".json")
            (JSON.toJSON openAPI)

openAPISchemaSpecViaDeclareSchemaRef ::
  forall a.
  (Typeable a, HasCodec a) =>
  FilePath ->
  Spec
openAPISchemaSpecViaDeclareSchemaRef filePath =
  describe ("openAPISchemaSpecViaDeclareSchemaRef @" <> nameOf @a) $ do
    it "outputs the same schema as before" $
      let (definitions, reference) = OpenAPI.runDeclare (OpenAPI.declareSchemaRef (Proxy :: Proxy (AutodocodecOpenApi a))) mempty
          json =
            JSON.object
              [ "definitions" JSON..= definitions,
                "reference" JSON..= reference
              ]
       in pureGoldenJSONFile
            ("test_resources/openapi-schema/declareSchemaRef/" <> filePath <> ".json")
            (JSON.toJSON json)
