/*    Copyright 2014 Duncan Jones
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.cryptonode.jncryptor;

/**
 * A basic validation class very similar to Apache Commons Lang.
 */
class Validate {

  private Validate() {
  }

  static void isTrue(boolean test, String msg, Object... args) {
    if (!test) {
      throw new IllegalArgumentException(String.format(msg, args));
    }
  }

  static void notNull(Object object, String msg, Object... args) {
    if (object == null) {
      throw new NullPointerException(String.format(msg, args));
    }
  }
  
  /**
   * Tests object is not null and is of correct length.
   * 
   * @param object
   * @param length
   * @param name
   */
  static void isCorrectLength(byte[] object, int length, String name) {
    Validate.notNull(object, "%s cannot be null.", name);

    Validate.isTrue(object.length == length,
        "%s should be %d bytes, found %d bytes.", name, length, object.length);
  }

}
