//
//  PacoJoinedExperimentsController.swift
//  Paco
//
//  Created by Timo on 10/29/15.
//  Copyright (c) 2015 Paco. All rights reserved.
//

import UIKit
import MessageUI


class PacoJoinedExperimentsController: UITableViewController,PacoExperimentProtocol,MFMailComposeViewControllerDelegate {
    
    
    
    var  myExpriments:Array<PAExperimentDAO>?
    let cellId = "ExperimenJoinedCellID"
    var selectedIndex = -1;
    var controller:PacoResponseTableViewController?
    var picker:MFMailComposeViewController?
    
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        let   lengthis:CGFloat    = self.bottomLayoutGuide.length
        
        let lengththat:CGFloat = self.topLayoutGuide.length
        self.tableView.contentInset = UIEdgeInsetsMake(lengththat, 0, lengthis, 0);
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

     let mediator = PacoMediator.sharedInstance();
     let  mArray:NSMutableArray  = mediator.startedExperiments();
     myExpriments = mArray as AnyObject  as? [PAExperimentDAO]
        
        
      NSNotificationCenter.defaultCenter().addObserver(self, selector:"eventJoined:", name:"JoinEvent", object: nil)
      tableView.tableFooterView = UIView()
    
        self.tableView.registerNib(UINib(nibName:"PacoJoinedExperimentsTableViewCell", bundle: nil), forCellReuseIdentifier:cellId)
            let swiftColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
            self.tableView.backgroundColor = swiftColor
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }
    
     func eventJoined(notification: NSNotification)
     {
        

        refreshTable()
        
    }
    
    func didClose(experiment: PAExperimentDAO)
    {
        
         let  m:PacoMediator =   PacoMediator.sharedInstance()
         let  experimentId  =   experiment.instanceId()
         myExpriments  = myExpriments!.filter() { $0 != experiment }
         m.stopRunningExperimentRegenerate(experimentId)
         let event:PacoEventExtended  = PacoEventExtended.stopEventForActionSpecificatonWithServerExperimentId(experiment, serverExperimentId: "not applicable")
        
         m.eventManager.saveEvent(event);
         m.eventManager.startUploadingEvents()
        
        
  
        
        self.tableView.reloadData()
   
        
    }
    
    
    
 func refreshTable()
{
    let  mediator =  PacoMediator.sharedInstance();
    let  mArray:NSMutableArray  = mediator.startedExperiments();
    
    myExpriments = mArray as AnyObject  as? [PAExperimentDAO]
    
    print("print the notificatins \(myExpriments)");
    self.tableView.reloadData()
    
    
}
    
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.tabBarController?.navigationItem.title = "Joined"
        
        refreshTable()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        var retVal:Int = 0
        if myExpriments  != nil
        {
            retVal =  myExpriments!.count
            
        }
        return retVal
    }
    
 
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        var  returnValue:CGFloat = 30
        
        if( indexPath.row == selectedIndex)
        {
            returnValue = 70
        }
        else
        {
            returnValue = 45
        }
        
        return  returnValue;
    }
 
  
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
            let dao:PAExperimentDAO!  =  myExpriments![indexPath.row]
        
            let experiment:PacoExperiment =    PacoExperiment.init(experimentDao:dao!)
        
            let numberOfGroups:Int32  =   dao.numberOfGroups()
        
           if(numberOfGroups == 1)
           {
               let group  = dao.soloGroup();
               let ctrler   = PacoQuestionScreenViewController.controllerWithExperiment(experiment,group:group)
               self.tabBarController!.navigationController?.pushViewController(  ctrler as! UIViewController  , animated: true)
            }
           else
           {
            
            
               let allGroups = dao.fetchExperimentGroupDictionary()
               let ctrler = PacoGroupSelectionController.init(nibNameAndGroups:allGroups , experiment: dao , nibName:"PacoGroupSelectionController")
               self.tabBarController!.navigationController?.pushViewController(  ctrler as! UIViewController  , animated: true)
            
           }
        
        
           // let ctrler   = PacoQuestionScreenViewController.controllerWithExperiment(experiment)
           // self.tabBarController!.navigationController?.pushViewController(  ctrler as! UIViewController  , animated: true)
        
    }
 
    
    func showEditView(experiment:PAExperimentDAO,indexPath:NSIndexPath)
    {
            
           print("the index is \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath) as! PacoJoinedExperimentsTableViewCell
        
        
        if(selectedIndex == indexPath.row)
        {
            selectedIndex = -1;
            
           cell.edit.setTitle("edit", forState: .Normal)
         
        }
        else
        {
            selectedIndex = indexPath.row;
            cell.edit.setTitle("close", forState: .Normal)
            
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.tableView.reloadRowsAtIndexPaths([indexPath],  withRowAnimation:UITableViewRowAnimation.None)
            
            
            
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellId, forIndexPath: indexPath) as! PacoJoinedExperimentsTableViewCell
        
        
        let dao:PAExperimentDAO = myExpriments![indexPath.row]
        var title:String?
        var description:String?
        var creator:String?
        
        if  dao.valueForKeyEx("title") != nil
        {
            title = (dao.valueForKeyEx("title")  as? String)!
        }
        
        if  dao.valueForKeyEx("description")  != nil
        {
            description = (dao.valueForKeyEx("description")  as? String)!
        }
        
        
        if  dao.valueForKeyEx("creator")  != nil
        {
            creator = (dao.valueForKeyEx("creator")  as? String)!
            cell.creator.text  = "by \(creator!)"
        }
        
        cell.indexPath = indexPath
        cell.parent = self;
        cell.experiment = dao
        cell.experimentTitle.text = title
        cell.selectionStyle  = UITableViewCellSelectionStyle.None
       
        return cell;
        
    }
    

    func didSelect(experiment:PAExperimentDAO)
    {
    
    }
    
    
    func email(experiment:PAExperimentDAO){

         sendMail(experiment)
    }
    
    
    func sendMail(experiment:PAExperimentDAO) {
        
        
        self.picker  = MFMailComposeViewController()
        self.picker!.mailComposeDelegate = self
       
        if  experiment.valueForKeyEx("contactEmail")  != nil
        {
           var  email  = (experiment.valueForKeyEx("contactEmail")  as? String)!
            var toRecipents = [email]
            self.picker!.setToRecipients(toRecipents)
            
        }
        
    
     
        picker!.setSubject("subject")
        picker!.setMessageBody("body", isHTML: true)
        presentViewController(picker!, animated: true, completion: nil)
        
        
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
  func editTime(experiment:PAExperimentDAO){
        
        
        
        
        let  arrayOfCells  = experiment.getTableCellModelObjects()
        
        if   arrayOfCells != nil && arrayOfCells?.isEmpty == false   {
            
            let  editor =  ScheduleEditor(nibName:"ScheduleEditor",bundle:nil)
            
            editor.cells = arrayOfCells!
            editor.experiment = experiment
            
            
            
                self.tabBarController?.navigationController?.pushViewController(editor, animated: true)
                
            
            
             }
    
    
    
    }

 
    
}
