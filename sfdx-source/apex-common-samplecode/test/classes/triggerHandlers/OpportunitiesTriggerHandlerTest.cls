/**
 * Copyright (c) 2012-2016, FinancialForce.com, inc
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, 
 *   are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, 
 *      this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, 
 *      this list of conditions and the following disclaimer in the documentation 
 *      and/or other materials provided with the distribution.
 * - Neither the name of the FinancialForce.com, inc nor the names of its contributors 
 *      may be used to endorse or promote products derived from this software without 
 *      specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
 *  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL 
 *  THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 *  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 *  OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/

/**
 * This test class demonstrates two approaches to unit testing, with and without DML, each has its own pros and cons
 **/
@IsTest
private class OpportunitiesTriggerHandlerTest 
{

	@IsTest
	private static void testValidationWithoutDML()
	{
		OpportunitiesTriggerHandler opps = new OpportunitiesTriggerHandler(new Opportunity[] { new Opportunity ( Name = 'Test', Type = 'Existing Account' ) } );
		opps.onValidate();
		System.Assert.areEqual(1, fflib_SObjectDomain.Errors.getAll().size());		
		System.Assert.areEqual('You must provide an Account for OpportunityTriggerHandler for existing Customers.', fflib_SObjectDomain.Errors.getAll()[0].message);
		System.Assert.areEqual(Opportunity.AccountId, ((fflib_SObjectDomain.FieldError)fflib_SObjectDomain.Errors.getAll()[0]).field); 		
	}
	
	@IsTest
	private static void testInsertValidationFailedWithoutDML()
	{
		Opportunity opp = new Opportunity ( Name = 'Test', Type = 'Existing Account' );
		fflib_SObjectDomain.Test.Database.onInsert(new Opportunity[] { opp } );		
		fflib_SObjectDomain.triggerHandler(OpportunitiesTriggerHandler.class);
		System.Assert.areEqual(1, fflib_SObjectDomain.Errors.getAll().size());		
		System.Assert.areEqual('You must provide an Account for OpportunityTriggerHandler for existing Customers.', fflib_SObjectDomain.Errors.getAll()[0].message);
		System.Assert.areEqual(Opportunity.AccountId, ((fflib_SObjectDomain.FieldError)fflib_SObjectDomain.Errors.getAll()[0]).field); 		
	}

	@IsTest
	private static void testUpdateValidationFailedWithoutDML()
	{
		Opportunity oldOpp = new Opportunity ( Name = 'Test', Type = 'Existing Account' );
		Opportunity newOpp = new Opportunity ( Name = 'Test', Type = 'New Account' );
		fflib_SObjectDomain.Test.Database.onUpdate(new Opportunity[] { newOpp }, new Map<Id, SObject> { newOpp.Id => oldOpp } );		
		fflib_SObjectDomain.triggerHandler(OpportunitiesTriggerHandler.class);
		System.Assert.areEqual(1, fflib_SObjectDomain.Errors.getAll().size());		
		System.Assert.areEqual('You cannot change the Opportunity type once it has been created.', fflib_SObjectDomain.Errors.getAll()[0].message);
		System.Assert.areEqual(Opportunity.Type, ((fflib_SObjectDomain.FieldError)fflib_SObjectDomain.Errors.getAll()[0]).field); 		
	}
	
	@IsTest
	private static void testInsertValidationSuccessWithoutDML()
	{
		Opportunity opp = new Opportunity ( Name = 'Test' );
		fflib_SObjectDomain.Test.Database.onInsert(new Opportunity[] { opp } );		
		fflib_SObjectDomain.triggerHandler(OpportunitiesTriggerHandler.class);
		System.Assert.isTrue(fflib_SObjectDomain.Errors.getAll().isEmpty());		
	}

}