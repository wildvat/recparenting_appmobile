/*
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: MIT-0
 */

package appmobile.recparenting

class MethodChannelResult(val result: Boolean, val arguments: Any?) {

    fun toFlutterCompatibleType(): Map<String, Any?> {
        return mapOf("result" to result, "arguments" to arguments)
    }
}