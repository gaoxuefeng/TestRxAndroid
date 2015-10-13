/*    Copyright 2013 Duncan Jones
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

import javax.crypto.SecretKey;

/**
 * A {@link JNCryptor} encrypts and decrypts data in a proprietary format
 * originally devised by Rob Napier.
 * <p>
 * See <a
 * href="https://github.com/rnapier/RNCryptor">https://github.com/rnapier/
 * RNCryptor</a> for details on the original implementation in objective-c
 */
public interface JNCryptor {

  /**
   * Generates a key given a password and salt using a PBKDF.
   * 
   * @param password
   *          password to use for PBKDF. Cannot be empty or <code>null</code>.
   * @param salt
   *          salt for password, cannot be <code>null</code>
   * @return the key
   */
  SecretKey keyForPassword(char[] password, byte[] salt)
      throws CryptorException;

  /**
   * Generates a key from a password and a random salt.
   * 
   * @param password
   *          password to use for PBKDF. Cannot be empty or <code>null</code>.
   * @return an object containing the key and the salt
   * @throws CryptorException
   * @since 1.2.0
   */
  PasswordKey getPasswordKey(char[] password) throws CryptorException;

  /**
   * Encrypts data using pre-computed keys, producing data in the password
   * output format (i.e. including salt values).
   * 
   * @param plaintext
   *          the plaintext to encrypt
   * @param encryptionKey
   *          the pre-computed encryption key
   * @param hmacKey
   *          the pre-computer HMAC key
   * @return the ciphertext, in the format described at <a href=
   *         "https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-Spec-v3.md"
   *         >https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-
   *         Spec-v3.md</a>
   * @throws CryptorException
   * @since 1.2.0
   */
  byte[] encryptData(byte[] plaintext, PasswordKey encryptionKey,
      PasswordKey hmacKey) throws CryptorException;
  
  /**
   * Encrypts data with the supplied password, salt values and IV.
   * 
   * @param plaintext
   *          the plaintext
   * @param password
   *          the password (cannot be <code>null</code> or empty)
   * @param encryptionSalt
   *          eight bytes of random salt value
   * @param hmacSalt
   *          eight bytes of random salt value
   * @param iv
   *          sixteen byte AES IV
   * @return the ciphertext, in the format described at <a href=
   *         "https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-Spec-v3.md"
   *         >https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-
   *         Spec-v3.md</a>
   * @throws CryptorException
   *           if an error occurred
   * @since 1.2.0
   */
  byte[] encryptData(byte[] plaintext, char[] password, byte[] encryptionSalt,
      byte[] hmacSalt, byte[] iv) throws CryptorException;  

  /**
   * Decrypts data with the supplied password.
   * 
   * @param ciphertext
   *          data to decrypt. Must be in the format described at <a href=
   *          "https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-Spec-v3.md"
   *          >https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor
   *          -Spec-v3.md</a>
   * @param password
   *          password to use for the decryption. Cannot be empty or
   *          <code>null</code>.
   * @return the plain text
   * @throws InvalidHMACException
   */
  byte[] decryptData(byte[] ciphertext, char[] password)
      throws CryptorException, InvalidHMACException;

  /**
   * Decrypts data with the supplied keys.
   * 
   * @param ciphertext
   *          data to decrypt. Must be in the format described at <a href=
   *          "https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-Spec-v3.md"
   *          >https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor
   *          -Spec-v3.md</a>
   * @param decryptionKey
   *          the key to decrypt with
   * @param hmacKey
   *          the key to verify the HMAC with
   * @return the plain text
   * @throws InvalidHMACException
   */
  byte[] decryptData(byte[] ciphertext, SecretKey decryptionKey,
      SecretKey hmacKey) throws CryptorException, InvalidHMACException;

  /**
   * Encrypts data with the supplied password.
   * 
   * @param plaintext
   *          the data to encrypt
   * @param password
   *          password to use for the encryption. Cannot be empty or
   *          <code>null</code>.
   * @return the ciphertext, in the format described at <a href=
   *         "https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-Spec-v3.md"
   *         >https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-
   *         Spec-v3.md</a>
   */
  byte[] encryptData(byte[] plaintext, char[] password) throws CryptorException;

  /**
   * Encrypts data with the supplied keys.
   * 
   * @param plaintext
   *          the data to encrypt
   * @param encryptionKey
   *          key to use for encryption
   * @param hmacKey
   *          key to use for computing the HMAC
   * @return the ciphertext, in the format described at <a href=
   *         "https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-Spec-v3.md"
   *         >https://github.com/RNCryptor/RNCryptor-Spec/blob/master/RNCryptor-
   *         Spec-v3.md</a>
   */
  byte[] encryptData(byte[] plaintext, SecretKey encryptionKey,
      SecretKey hmacKey) throws CryptorException;

  /**
   * Returns the version number of the data format produced by this
   * {@code JNCryptor}.
   * 
   * @return the version number
   */
  int getVersionNumber();

  /**
   * Changes the number of iterations used by this {@code JNCryptor}.
   * 
   * @param iterations
   * @since 0.4
   */
  void setPBKDFIterations(int iterations);

  /**
   * Gets the number of iterations used by this {@code JNCryptor}.
   * 
   * @return the number of PBKDF2 iterations
   * @since 1.0.0
   */
  int getPBKDFIterations();
}
